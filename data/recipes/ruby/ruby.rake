#
# Muster recipe for ruby version 1.2.3
#
Muster::Dependency.new( "ruby", "1.8.6-p114") do |t|
  t.depends_on( "openssl" )
  t.depends_on( "zlib" )

  t.upstream_source  = "ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.6-p114.tar.gz"
  t.upstream_md5     = "500a9f11613d6c8ab6dcf12bec1b3ed3"

  ENV["CPPFLAGS"]= "-I#{File.join( t.install_dir, 'usr', 'include')}"
  ENV["LDFLAGS"] = "-L#{File.join( t.install_dir, 'usr', 'lib' )}"

  def t.build
    # put the .a files from the fakeroot/usr/lib directory into the package
    # directory so the compilation can use them
    %w[ libz.a libcrypto.a libssl.a ].each do |f| 
      FileUtils.cp File.join( install_dir, "usr", "lib", f ), pkg_dir, :verbose => true
    end 
    sh "./configure --disable-shared --prefix=#{File.join( '/', 'usr' )}"
    sh "make"
  end

  t.install_commands << "make install DESTDIR=#{t.install_dir}"

end