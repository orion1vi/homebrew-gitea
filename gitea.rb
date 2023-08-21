require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.20.3"

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
             when "linux-386" then "77c4194e2233986dd0e2c0a0c240a458877339d02ce90da3a468b21b63e37e5c"   # binary
             when "linux-amd64" then "1e378dd75460762b08902684cad58907de0cc1e297bc626b89dee6559dee7b99"
             when "linux-arm64" then "6a737f2da553b4246ec5499c2449f99bc93fef9f3bf3c9fea3e5f7639ff679d2" # binary
             when "darwin-10.12-amd64" then "f6726872271259f1f818ed155119a1b09887504d321d98e509ac0f4dc33cc647"
             when "darwin-10.12-arm64" then "c14708624c8282cfa95d4dd8e90fa49d04003190147ed29885587015965f2ddb"
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
