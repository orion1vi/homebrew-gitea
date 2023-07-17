require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.20.0"

  os = OS.mac? ? "darwin-10.12" : "linux"
  arch = case Hardware::CPU.arch
         when :i386 then "386"
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "gitea: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "gitea-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.com/gitea/#{version}/#{@@filename}"
  @@using = :nounzip

  if os == "darwin-10.12" || arch == "amd64"
    @@url += ".xz"
    @@using = nil
    depends_on "xz"
  end

  @@sha256 = case "#{os}-#{arch}"
             when "linux-386" then "79aaca881dd013fef38223405371a30c9a35d38820a463395b1bdf9e4cab44fe"   # binary
             when "linux-amd64" then "bf29d0de3f2adb7c1ccfeda461657b00109ae993339cb751dea05ca815ec7979"
             when "linux-arm64" then "ba0e5fe11a55b274ee5dd30d471f5d7983344739342cf087b5d726ebdb135950" # binary
             when "darwin-10.12-amd64" then "375ec5b2920f0ce750ce8d6e6e420e4ebde998affeb469aaadc466ee520fddfa"
             when "darwin-10.12-arm64" then "cb976b62abd85467aa59b71d30fd7d88692a424b7efdf6dd9e71e1be1f75ccf1"
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
