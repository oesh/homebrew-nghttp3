class Nghttp3 < Formula
  desc "HTTP/3 C Library"
  homepage "https://github.com/ngtcp2/nghttp3"
  url "https://github.com/ngtcp2/nghttp3/archive/draft-28.zip"
  sha256 "11bdeb68a095852677f0f5281b71e621d4bc29514fb1740c07864e5621058b93"
  license "MIT"

  bottle do
    sha256 "d81b96cf82189cd4049ff7fe400a4e5b05eed38029d34e8325b751e7b9f3d730" => :catalina
    sha256 "718a1b33f18b2b72b92110d2fb3f83e9ab6e4831f9bc2bdf7636757129104552" => :mojave
    sha256 "f56e7c923879fd77d7c9737395c7c5df1ab3e9ffa03baa900385b53a91469803" => :high_sierra
  end

  head do
    url "https://github.com/ngtcp2/nghttp3.git"
    depends_on "cmake" => :build
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    mkdir "build" do
        system "cmake", "..", *std_cmake_args
        system "make"
        system "make", "check"
        system "make", "qpack"
        system "make", "install"

        ohai "Insatlling nghttp3_qpack"
        bin.install "examples/qpack" => "nghttp3_qpack"
    end
  end

  test do
      (testpath/"testfile.txt").write("Hello\tworld\n\n")
      system "#{bin}/nghttp3_qpack", "encode", "testfile.txt", "encoded.txt"
      system "#{bin}/nghttp3_qpack", "decode", "encoded.txt", "decoded.txt"
      system "diff", "testfile.txt", "decoded.txt"
  end
end
