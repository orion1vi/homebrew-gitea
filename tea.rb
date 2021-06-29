class Tea < Formula
  desc "A command line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  version "0.7.0"

  os = OS.mac? ? "darwin" : "linux"
  arch = case Hardware::CPU.arch
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "tea: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "tea-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.io/tea/#{version}/#{@@filename}.xz"
  @@sha256 = case "#{os}-#{arch}"
             when "linux-amd64" then "c49ef093f649a9ea74fb16954a51626ebd1b494c9143b000dad5fc935cb62527"
             when "linux-arm64" then "6497398cefed6536cb2f524a93b38edbf8e7635d01bed12e18334430a4fcb9c0"
             when "darwin-amd64" then "245cf071858c25ee594bbfec0cc0bcc19ae9219de09d8221daa660cb82592e4b"
             else
               raise "tea: Unsupported system #{os}-#{arch}"
             end

  url @@url
  sha256 @@sha256

  conflicts_with "tea-head", because: "both install tea binaries"
  bottle :unneeded
  def install
    filename = Tea.class_variable_get("@@filename")
    bin.install filename => "tea"
  end

  test do
    system "#{bin}/tea", "--version"
  end
end
