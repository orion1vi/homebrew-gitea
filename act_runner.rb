require_relative './utils/macos_codesign.rb'

class ActRunner < Formula
  desc "A runner for Gitea based on act"
  homepage "https://gitea.com/gitea/act_runner"
  version "0.2.5"
  license "MIT"

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
             when "linux-amd64" then "2599afde661c8cb70fbded9d7d5815c8f83d91c4b7c4a25c71fe1a9227f9253f"
             when "linux-arm64" then "c4ff8b4ed44288b5773ee37847a00a9953c9232ecab2e835b910c0999e4d567e" # binary
             when "darwin-amd64" then "d6263fcc4117d43ebb2cdec33de5ef8befaed6115d431de81153bf5b207c65fb"
             when "darwin-arm64" then "d51086aefecae126b1546454013956023877de05eae215623b4bed0e63e212d6"
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
