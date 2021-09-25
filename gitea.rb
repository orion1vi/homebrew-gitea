class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.15.3"

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
             when "linux-386" then "98d1fde4d9085ca9fec04ac491e17a4b371e8f7b8de631770944715a0e911616"
             when "linux-amd64" then "c9ba0e981ef46245bfe13a074e8fb9410981909dcd3abb471345a7b9ceabd574"
             when "linux-arm64" then "e865b914eb84dde8bd64a86a60066ad5c61bba3a2a15e4b03ec6048efd0b45d6"
             when "darwin-10.12-amd64" then "ba67f009856da4ddba29e65b8adbf7be0c2d8de39d70572641342b9e7532c93e"
             when "darwin-10.12-arm64" then "367e2e1b98828e26910cb1701845a6fba4183954337107a0967a08f551986e33"
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
