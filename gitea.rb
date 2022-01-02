require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.15.9"

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
             when "linux-386" then "8ba76b03c57f1a099e270523e945855b8f52e1801eb55cea6ac1e5fbf78e32d2"   # binary
             when "linux-amd64" then "0e8b7235fa480953dfaac31a77a9a0695925f1bfde7b777f5a4d4510474fd8ce"
             when "linux-arm64" then "52733aa156b5998d76574318623978fbf3daf4142ed0887cfcd618cc9da911e6" # binary
             when "darwin-10.12-amd64" then "9723b45c5dc6987e12f5212c52a526e1549d9e105425071e84d7c85539b02c44"
             when "darwin-10.12-arm64" then "5e80c1bb4bed6c84e7264383feb01ef00f1cc4e030aa3e33f3f1d6ab5a1d3794"
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
