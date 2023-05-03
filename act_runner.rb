require_relative './utils/macos_codesign.rb'

class ActRunner < Formula
  desc "A runner for Gitea based on act"
  homepage "https://gitea.com/gitea/act_runner"
  version "0.1.6"

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
             when "linux-amd64" then "54c54dcf9337a7f154ca156269129022babaf5cb44574132c0c4a51e2e4b43ac"
             when "linux-arm64" then "7dd14455235bbdb3ed6059da137597fcf649f3e48343354601ae6e6214d7603f" # binary
             when "darwin-amd64" then "db772791ace78e6c821a89b6b3fbadb670ca9c8c0795f9c8ba8dfdd99317fe5e"
             when "darwin-arm64" then "9970d43e87b78e6ea1132242cefe92fc7c778de98a40c29494b36c441d9e94de"
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
