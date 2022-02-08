require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.16.1"

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
             when "linux-386" then "3fd31357def644b3d82f0c47b22cef707e48312885802227d4749ed1a232de11"   # binary
             when "linux-amd64" then "389d3e43a89b38ac1af6f82d5ab817f5281572f4335086afe27e31d4de985d20"
             when "linux-arm64" then "051bfe0a57a3458fb68b6d90d1025669bae02643dd1d4f3a461afb61ebaa2e49" # binary
             when "darwin-10.12-amd64" then "431c59d035bb24108ca431425adc5c107a96d4432a4285555a29bcfe3d900f1d"
             when "darwin-10.12-arm64" then "791d8f6493a1cea3d95ae3983879eec30f7d41f56f5e5e6293df60c4ba4b3f8c"
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
