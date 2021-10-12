class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.15.4"

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
             when "linux-386" then "cb8d0d82ebea546d4f6db1aa80f62d5a382c9b1c3116278dff41e462352a0e5c"   # binary
             when "linux-amd64" then "d44dc105a0d8dedf051e36b0eef7c94b56e0c478a78c3575ab1cacf2f4cf77c1"
             when "linux-arm64" then "a40c22504507915d3acccc146052415b1ece5c86db2facf34d78fc887128515f" # binary
             when "darwin-10.12-amd64" then "c2208e84a73536a881372ee301dc5872015af51dd9a31039b495010a656b5fca"
             when "darwin-10.12-arm64" then "3efd6e61bb45c1fb9da0c5ecf84f05c15fd8a94caf2db2aefa5962a3270d49d7"
             else
               raise "gitea: Unsupported system #{os}-#{arch}"
             end

  sha256 @@sha256
  url @@url,
      using: @@using

  conflicts_with "gitea-head", because: "both install gitea binaries"
  bottle :unneeded
  def install
    if stable.using.blank?
      filename = Gitea.class_variable_get("@@filename")
    else
      filename =  downloader.cached_location
    end
    bin.install filename => "gitea"
  end

  test do
    system "#{bin}/gitea", "--version"
  end
end
