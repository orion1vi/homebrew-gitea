require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.18.2"

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
             when "linux-386" then "288473a46924a47f9128330eda4cf588272119f9d80bbfdc7862c3ffa85471b7"   # binary
             when "linux-amd64" then "60c86f4d61da12e04ec38a22f30ee499bfd7c43e6986e733e32007c748e0e5fd"
             when "linux-arm64" then "d8e82dc4419e90f3fd31691d481965f36ad03872124732b8a4eb3a9280ff4da8" # binary
             when "darwin-10.12-amd64" then "7918e02e51e34a335a72f7c46374e7b94276e255c7457570eb71b38f85288a19"
             when "darwin-10.12-arm64" then "c098950f19239ab83c4ac79d1df82c932fc9bfb23a8139ab1406ed9703f38c06"
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
