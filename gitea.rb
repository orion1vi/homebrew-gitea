class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.15.2"

  os = OS.mac? ? "darwin-10.12" : "linux"
  arch = case Hardware::CPU.arch
         when :i386 then "386"
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "gitea: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "gitea-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.io/gitea/#{version}/#{@@filename}.xz"
  @@sha256 = case "#{os}-#{arch}"
             when "linux-386" then "aaf6d9edd62ac1da7b45aede00878aef92b7b9b2a9f732204a9270c734ee6229"
             when "linux-amd64" then "da8a29ae062842fd68a3806ad73c5bafde5db37a66121fb23dd4a9136e72dec4"
             when "linux-arm64" then "d64bd26470598734a1e15a725ebf0c0f061291c631001e2debf0c755815e5959"
             when "darwin-10.12-amd64" then "c41943f7e11af23ed13b3e7830156a708bfe4ca0a24ce328660aa9cb81425cc1"
             when "darwin-10.12-arm64" then "cc17aae24089959c9ccd095e58bca5a3988d6af5fcf822e488af7cb74da98301"
             else
               raise "gitea: Unsupported system #{os}-#{arch}"
             end

  url @@url
  sha256 @@sha256

  conflicts_with "gitea-head", because: "both install gitea binaries"
  bottle :unneeded
  def install
    filename = Gitea.class_variable_get("@@filename")
    bin.install filename => "gitea"
  end

  test do
    system "#{bin}/gitea", "--version"
  end
end
