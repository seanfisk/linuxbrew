require 'formula'

class Pcre < Formula
  homepage 'http://www.pcre.org/'
  url 'https://downloads.sourceforge.net/project/pcre/pcre/8.35/pcre-8.35.tar.bz2'
  mirror 'ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.35.tar.bz2'
  sha256 'a961c1c78befef263cc130756eeca7b674b4e73a81533293df44e4265236865b'

  bottle do
    cellar :any
    sha1 "be65f007b73eeede8b965c0d7fc1c3d1a4bce087" => :mavericks
    sha1 "a0358dc5793923703258bd6a4fb9e5a5e44a358e" => :mountain_lion
    sha1 "6f7043ff5e9ad854dfe98e0399045d0f62209402" => :lion
  end

  option "without-check", "Skip build-time tests (not recommended)"
  option :universal

  fails_with :llvm do
    build 2326
    cause "Bus error in ld on SL 10.6.4"
  end

  # Upstream patch to fix compilation with GCC 4.9
  patch do
    url "http://bugs.exim.org/attachment.cgi?id=741"
    sha1 "bad236cf67a7b42f0dc8d4ae05ed0260241320d1"
  end

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-utf8",
                          "--enable-pcre8",
                          "--enable-pcre16",
                          "--enable-pcre32",
                          "--enable-unicode-properties",
                          "--enable-pcregrep-libz",
                          "--enable-pcregrep-libbz2",
                          "--enable-jit"
    system "make"
    ENV.deparallelize
    system "make test" if build.with? "check"
    system "make install"
  end
end
