package Blio::Image;
use 5.010;
use Moose;
use namespace::autoclean;
use Digest::SHA1;
use Path::Class;
use File::Copy;
use Imager;

has 'base_dir' => ( is => 'ro', isa => 'Path::Class::Dir', required => 1 );
has 'source_file' =>
    ( is => 'ro', isa => 'Path::Class::File', required => 1 );
has 'target_file' =>
    ( is => 'ro', isa => 'Path::Class::File', required => 1, lazy_build=>1 );
sub _build_target_file {
    my $self = shift;
    return $self->source_file->relative($self->base_dir);
}
has 'thumbnail' =>
    ( is => 'ro', isa => 'Path::Class::File', required => 1, lazy_build=>1);
sub _build_thumbnail {
    my $self = shift;
    my $th = $self->source_file->relative($self->base_dir)->stringify;
    $th=~s{/([^/]+)$}{/th_$1};
    return file($th);
}

sub publish {
    my ($self, $blio) = @_;

    $blio->output_dir->file($self->target_file)->parent->mkpath;
    my $from = $self->source_file->stringify;
    my $to = $blio->output_dir->file($self->target_file)->stringify;
    copy($from, $to) || die "Cannot copy $from to $to: $!";
}

sub make_thumbnail {
    my ($self, $blio) = @_;

    $blio->output_dir->file($self->target_file)->parent->mkpath;
    my $file = $self->source_file->stringify;
    my $target = $blio->output_dir->file($self->thumbnail)->stringify;
    my $image = Imager->new;
    $image->read(file=>$file) || die "Cannot read image $file: ".$image->errstr;
    my $thumbnail = $image->scale(xpixels => 300) || die "Cannot scale $file: ".$image->errstr;
    $thumbnail->write( file => $target ) || die "Cannot write thumbnail $target" . $thumbnail->errstr;
}


__PACKAGE__->meta->make_immutable;
1;
