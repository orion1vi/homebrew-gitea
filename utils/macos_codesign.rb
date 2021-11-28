## this file is licensed under BSD-2-Clause License (https://github.com/Homebrew/brew/blob/4665bb8e663c6d0ef452f4c124742732c96f8fd6/LICENSE.txt)
## source: https://github.com/homebrew/brew/blob/4665bb8e663c6d0ef452f4c124742732c96f8fd6/Library/Homebrew/os/mac/keg.rb

def apply_ad_hoc_signature(file)
    return if MacOS.version < :big_sur
    return unless Hardware::CPU.arm?

    odebug "Codesigning #{file}"
    # Use quiet_system to squash notifications about resigning binaries
    # which already have valid signatures.
    return if quiet_system("codesign", "--sign", "-", "--force",
                           "--preserve-metadata=entitlements,requirements,flags,runtime",
                           file)

    # If the codesigning fails, it may be a bug in Apple's codesign utility
    # A known workaround is to copy the file to another inode, then move it back
    # erasing the previous file. Then sign again.
    #
    # TODO: remove this once the bug in Apple's codesign utility is fixed
    Dir::Tmpname.create("workaround") do |tmppath|
      FileUtils.cp file, tmppath
      FileUtils.mv tmppath, file, force: true
    end

    # Try signing again
    odebug "Codesigning (2nd try) #{file}"
    return if quiet_system("codesign", "--sign", "-", "--force",
                           "--preserve-metadata=entitlements,requirements,flags,runtime",
                           file)

    # If it fails again, error out
    onoe <<~EOS
      Failed applying an ad-hoc signature to #{file}
    EOS
end