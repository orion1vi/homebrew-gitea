require_relative './utils/macos_codesign.rb'

class ActRunner < Formula
  desc "A runner for Gitea based on act"
  homepage "https://gitea.com/gitea/act_runner"
  version "0.2.3"

  os = OS.mac? ? "darwin" : "linux"
  arch = case Hardware::CPU.arch
         when :i386 then "386"
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "act_runner: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "act_runner-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.com/act_runner/#{version}/#{@@filename}"
  @@url += ".xz"
  @@using = nil
  depends_on "xz"

  @@sha256 = case "#{os}-#{arch}"
             when "linux-amd64" then "23fa2984493d9a888c0d13efe2e19c1f5c1f480c9d994e6e9d7e9690b510e833"
             when "linux-arm64" then "5c1811e55c3085cd964e5d4a09f63a8ac485f27b7b5b970aa0960e6fe894e96f" # binary
             when "darwin-amd64" then "411973c5722c7403b2c7ab0c10ca19031ffa764994f081ea436e751e3ceea05d"
             when "darwin-arm64" then "6b903b43b7de1af05f9699150c541e5294fa79ca4a9fed7715a025669fbce02b"
             else
               raise "act_runner: Unsupported system #{os}-#{arch}"
             end

  sha256 @@sha256
  url @@url,
    using: @@using

  conflicts_with "act_runner-head", because: "both install act_runner binaries"
  def install
    if stable.using.blank?
      filename = ActRunner.class_variable_get("@@filename")
    else
      filename = downloader.cached_location
    end
    apply_ad_hoc_signature(filename)
    bin.install filename => "act_runner"
  end

  test do
    system "#{bin}/act_runner", "--version"
  end
end
