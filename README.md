# Archive::Libarchive::Unwrap ![linux](https://github.com/uperl/Archive-Libarchive-Unwrap/workflows/linux/badge.svg)

Unwrap files with multiple compression / encoding formats

# SYNOPSIS

```perl
use Archive::Libarchive::Unwrap;

my $uw = Archive::Libarchive::Unwrap->new( filename => 'hello.txt.uu' );
print $uw->unwrap;
```

# DESCRIPTION

This module will unwrap one or more nested filter formats supported by [Archive::Libarchive](https://metacpan.org/pod/Archive::Libarchive).  The detection
logic for [Archive::Libarchive](https://metacpan.org/pod/Archive::Libarchive) is such that you typically do not need to tell it which formats are a file
is stored using.  The filter formats include traditional compression formats like gzip, bzip2, but also includes
other encodings like uuencode.  The idea of this module is to just point it to a file and it will do its best
to decode it until you get to the inner file.

# CONSTRUCTOR

## new

```perl
my $uw = Archive::Libarchive::Unwrap->new(%options);
```

This creates a new instance of the Unwrap class.  At least one of the `filename` and `memory` options are
required.

- filename

    ```perl
    my $uw = Archive::Libarchive::Unwrap->new( filename => $filename );
    ```

    This will create an Unwrap instance that will read from the given `$filename`.

- memory

    ```perl
    my $uw = Archive::Libarchive::Unwrap->new( memory => $memory );
    my $uw = Archive::Libarchive::Unwrap->new( memory => \$memory );
    ```

    This will create an Unwrap instance that will read from memory.  You may pass in either a scalar containing
    the raw wrapped data, or a scalar reference to the same.

# METHODS

## unwrap

```perl
my $content = $uw->unwrap;
```

This will return the raw content of the unfiltered file.  This will decompress and/or filter multiple
filters, so if you had a text file that was gzipped and uuencoded `hello.txt.gz.uu`, this method will
return the content of the inner text file `hello.txt`.

# SEE ALSO

- [Archive::Libarchive::Peek](https://metacpan.org/pod/Archive::Libarchive::Peek)

    An interface for peeking into archives without extracting them to the local filesystem.

- [Archive::Libarchive::Extract](https://metacpan.org/pod/Archive::Libarchive::Extract)

    An interface for extracting files from an archive.

- [Archive::Libarchive](https://metacpan.org/pod/Archive::Libarchive)

    A lower-level interface to `libarchive` which can be used to read/extract and create
    archives of various formats.

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2021 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
