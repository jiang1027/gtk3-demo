# #!@PERL@ -w

$output_file = shift(@ARGV);

open(FH, '>', $output_file) or die "cannot write '@output_file'\n";

print FH <<EOT;
typedef	GtkWidget *(*GDoDemoFunc) (GtkWidget *do_widget);

typedef struct _Demo Demo;

struct _Demo 
{
  gchar *name;
  gchar *title;
  gchar *filename;
  GDoDemoFunc func;
  Demo *children;
};

EOT

for $file (@ARGV) {
    my %demo;
    
    ($basename1 = $file) =~ s/\.c$//;
	($basename = $basename1) =~ s/\.\.\/gtk-demo\///;
	
    open INFO_FILE, $file or die "Cannot open '$file'\n";
    $title = <INFO_FILE>;
    $title =~ s@^\s*/\*\s*@@;
    $extra = "";
    if ($title =~ /^(.*)::(.*)$/) {
        $title = $1;
        $extra = " $2";
    }
    $title =~ s@\s*$@@;
    $extra =~ s@^\s*@@;
    $extra =~ s@\s*$@@;

    close INFO_FILE;

    print FH "GtkWidget *do_$basename (GtkWidget *do_widget);\n";

    push @demos, {"name" => $basename, "title" => $title, "file" => "$file $extra",
		  "func"  => "do_$basename"};
}

# generate a list of 'parent names'
foreach $href (@demos) {
    if ($href->{"title"} =~ m|^([-\w\s]+)/[-\w\s]+$|) {
	my $parent_name = $1;
	my $do_next = 0;

	# parent detected
	if ( @parents) {
	    foreach $foo (@parents) {
		if ($foo eq $parent_name) {
		    $do_next = 1;
		}
	    }
	    
	    if ($do_next) {
		next;
	    }
	}

	push @parents, $parent_name;

	$tmp = ( @child_arrays)?($#child_arrays + 1):0;
	push @child_arrays, "child$tmp";

	push @demos, {"name" => "NULL", "title" => $parent_name, "file" => "NULL",
		      "func" => "NULL"};
    }
}

if ( @parents) {
    $i = 0;
    for ($i = 0; $i <= $#parents; $i++) {
	$first = 1;
	
	print FH "\nDemo ", $child_arrays[$i], "[] = {\n";
	
	$j = 0;
	for ($j = 0; $j <= $#demos; $j++) {
	    $href = $demos[$j];
	    
	    if (! $demos[$j]) {
		next;
	    }
	    
	    if ($demos[$j]{"title"} =~ m|^$parents[$i]/([-\w\s]+)$|) {
		if ($first) {
		    $first = 0;
		} else {
		    print FH ",\n";
		}
		
		print FH qq (  { "$demos[$j]{name}", "$1", "$demos[$j]{file}", $demos[$j]{func}, NULL });

		# hack ... ugly
		$demos[$j]{"title"} = "foo";
	    }
	}

	print FH ",\n";
	print FH qq (  { NULL } );
	print FH "\n};\n";
    }   
}

# sort @demos
@demos_old = @demos;

@demos = sort {
    $a->{"title"} cmp $b->{"title"};
} @demos_old;

# sort the child arrays
if ( @child_arrays) {
    for ($i = 0; $i <= $#child_arrays; $i++) {
	@foo_old = @{$child_arrays[$i]};

	@{$child_arrays[$i]} = sort {
	    $a->{"title"} cmp $b->{"title"};
	} @foo_old;
    }
}

# toplevel
print FH "\nDemo gtk_demos[] = {\n";

$first = 1;
foreach $href (@demos) {
    $handled = 0;

    # ugly evil hack
    if ($href->{title} eq "foo") {
	next;
    }

    if ($first) {
	$first = 0;
    } else {
	print FH ", \n";
    }

    if ( @parents) {
	for ($i = 0; $i <= $#parents; $i++) {
	    if ($parents[$i] eq $href->{title}) {

		if ($href->{file} eq 'NULL') {
		    print FH qq (  { NULL, "$href->{title}", NULL, $href->{func}, $child_arrays[$i] });
		} else {
		    print FH qq (  { "$href->{name}", "$href->{title}", "$href->{file}", $href->{func}, $child_arrays[$i] });
		}
		
		$handled = 1;
		last;
	    }
	}
    }
    
    if ($handled) {
	next;
    }
    
    print FH qq (  { "$href->{name}", "$href->{title}", "$href->{file}", $href->{func}, NULL });
}

print FH ",\n";
print FH qq (  { NULL } );
print FH "\n};\n";

close(FH);

exit 0;
