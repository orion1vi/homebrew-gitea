require_relative './utils/macos_codesign.rb'

class TeaHead < Formula
  desc "A command line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  version "main"

  os = OS.mac? ? "darwin" : "linux"
  arch = case Hardware::CPU.arch
         when :i386 then "386"
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "tea: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "tea-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.com/tea/#{version}/#{@@filename}"
  @@using = :nounzip

  if os == "darwin" || arch == "amd64"
    @@url += ".xz"
    @@using = nil
    depends_on "xz"
  end

  @@sha256 = %x[ curl -sL #{@@url}.sha256 ].split.first

  sha256 @@sha256
  url @@url,
      using: @@using

  conflicts_with "tea", because: "both install tea binaries"
  def install
    if stable.using.blank?
      filename = TeaHead.class_variable_get("@@filename")
    else
      filename =  downloader.cached_location
    end
    apply_ad_hoc_signature(filename)
    bin.install filename => "tea"
  end

  test do
    system "#{bin}/tea", "--version"
  end
end
