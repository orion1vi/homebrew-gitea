require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.16.5"

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
             when "linux-386" then "1ae85d435c4dd95f4a47f45349d4fa06cbc39de7473ebd9f95bd67676d3ea802"   # binary
             when "linux-amd64" then "9f23745a532bc698ec4109151c3b5997eff1d81c39bb0dbca151dd6f1afcac2c"
             when "linux-arm64" then "e442d45e86d67e13c109e3d92ebb3482edc7487167ca284f5188a13246069329" # binary
             when "darwin-10.12-amd64" then "0e47a05761a69aca9da8fa28d731b23ba9bfdf13f1c0b9c95be5329b4662014a"
             when "darwin-10.12-arm64" then "6035e642b3534cbf82797a4a7f266c4a8e09dc23ecf2363cf057025d9e0da753"
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
