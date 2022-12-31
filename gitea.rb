require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.18.0"

  os = OS.mac? ? "darwin-10.12" : "linux"
  arch = case Hardware::CPU.arch
         when :i386 then "386"
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "gitea: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "gitea-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.io/gitea/#{version}/#{@@filename}"
  @@using = :nounzip

  if os == "darwin-10.12" || arch == "amd64"
    @@url += ".xz"
    @@using = nil
    depends_on "xz"
  end

  @@sha256 = case "#{os}-#{arch}"
             when "linux-386" then "e566b8d526d37b4946312da479242ec98ddd0a158e4593fd73cb223dd3cf8307"   # binary
             when "linux-amd64" then "a608a3f074344ed2d68460c98e63d1f5125b23395e5b2a3b49a6dc8d0bd90d35"
             when "linux-arm64" then "0b5ea921a1fc7e69cf13bd578b2bdad10964ce49225aa5eb158435137f82f3f1" # binary
             when "darwin-10.12-amd64" then "a332c9edda62f71c0bb158b8d133d3d22b405600e0937f86bde66974fe5cf4e3"
             when "darwin-10.12-arm64" then "d7d4e66a031e11a81bc51b65f6b0c119969c594837e7469f64b4608e0d9b44e9"
             else
               raise "gitea: Unsupported system #{os}-#{arch}"
             end

  sha256 @@sha256
  url @@url,
      using: @@using

  conflicts_with "gitea-head", because: "both install gitea binaries"
  def install
    if stable.using.blank?
      filename = Gitea.class_variable_get("@@filename")
    else
      filename =  downloader.cached_location
    end
    apply_ad_hoc_signature(filename)
    bin.install filename => "gitea"
  end

  test do
    system "#{bin}/gitea", "--version"
  end
end
