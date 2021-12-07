require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.15.7"

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
             when "linux-386" then "6cc2fa9412ca6dc985a8d185aaa2d08c5d3156a373ae527c506571c1564a76b5"   # binary
             when "linux-amd64" then "ec79c71bc33d8712cacfd931d53c966be578c6f7d6aab8ff8a22a30b9cf5e562"
             when "linux-arm64" then "c30bde918965fc23d7ab51b9ca11df320cf6423096ddfaf2f6c6468cab9ce421" # binary
             when "darwin-10.12-amd64" then "0313154fd59eab758fe585ddc4496514805e633743631f946d50d7f306305b0b"
             when "darwin-10.12-arm64" then "f3ccc0591664c263c0f06590d8bcd8e2c7f5ffeac3c14066b062667d7662798e"
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
