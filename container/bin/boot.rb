#!/usr/bin/env ruby
# encoding: BINARY
# warn_indent: true
# frozen_string_literal: true

# This script starts a QEMU child process wearing a VNC sock and acts as
# middleman between the socket and stdin/out. Perfect for VNC clients that
# utilize binary websockets (ex: noVNC.js).
#
# Usage: ./boot.rb /root/images [/usr/local/bin/qemu-system-i386]

require "fileutils"
require "socket"
require "timeout"

# folder containing the OS's hdd.img, other instance files will also go here
# default for container is set, can be optionally overridden by first argument
base_path = ARGV[0] || "/home/vm"

# location of QEMU binary (`qemu-system-i386` here, or `-x86_64` for 64-bit)
# default for container is set, can be optionally overridden by second argument
qemu_path = ARGV[1] || "/usr/bin/qemu-system-i386"

# create a temporary directory for each instance from PID
# NOTE: not needed when containerized, everything's already ephemeral
# instance_dir = "/tmp/y2k.#{$$}"

# flush data immediately to stdout instead of buffering
# https://ruby-doc.org/core-2.7.0/IO.html#method-i-sync-3D
$stdout.sync = true

begin
  # make the temp dir for our new instance & grab a fresh copy of the OS
  # NOTE: not needed when containerized, everything's already ephemeral
  # FileUtils.makedirs(instance_dir)
  # FileUtils.cp(base_img, "#{instance_dir}/hdd.img")

  # open a catch-all log file
  log_file = File.open("#{base_path}/out.log", "w")

  # start QEMU as a child process (TODO: put config somewhere more manageable)
  qemu = spawn qemu_path,
    "-drive", "file=#{base_path}/hdd.img,format=qcow2",
    "-cpu", "pentium3,enforce",
    "-m", "96",
    "-net", "none",
    "-serial", "none",
    "-parallel", "none",
    "-vga", "std",
    "-usb",
    "-device", "usb-tablet",
    "-rtc", "base=localtime",
    "-no-acpi",
    "-no-reboot",
    "-nographic",
    "-vnc", "unix:#{base_path}/vnc.sock",
    { :in => :close, :out => log_file, :err => log_file }

  # limit CPU usage of each VM (if host supports it)
  # NOTE: setting --cpus with Docker makes this redundant
  # if File.exist?("/usr/bin/cpulimit")
  #   cpulimit = spawn "/usr/bin/cpulimit",
  #     "--pid", "#{qemu}",
  #     "--limit", "90",
  #     { :in => :close, :out => log_file, :err => log_file }
  # end

  # wait until the VNC socket is created; only takes a fraction of a second (if
  # the server load is low) but everything following this will freak the f*ck
  # out if it's not there yet
  Timeout.timeout(15) do
    until File.exist?("#{base_path}/vnc.sock")
      sleep 0.02
    end
  end

  # attach ourselves to the VM's VNC socket made by QEMU
  sock = UNIXSocket.new("#{base_path}/vnc.sock")

  # everything's all set up now, time to simply pass data between user and VM
  while $stdin do
    begin
      # monitor the IO buffer for unprocessed data (read from both directions)
      read, _, err = IO.select([$stdin, sock], nil)

      # break out of loop if anything goes wrong, doesn't really matter what tbh
      if err.any?
        break
      end

      # pass input from user to VM
      if read.include?($stdin)
        data = $stdin.readpartial(4096)
        sock.write(data) unless data.empty?
      end

      # pass output from VM to user
      if read.include?(sock)
        data = sock.readpartial(4096)
        $stdout.write(data) unless data.empty?

        # send output immediately (see $stdout.sync above)
        $stdout.flush
      end
    rescue EOFError
      # we stopped receiving input from the user's end, so don't expect any more
      break
    end
  end
ensure
  # the user's done (or we crashed) so stop their personal VM; everything else
  # will be deleted along with the Docker container
  Process.kill(:SIGTERM, qemu) if qemu

  # kill cpulimit if it didn't stop itself already
  # Process.kill(:SIGTERM, cpulimit) if cpulimit

  # ...and delete their hard drive, logs, etc.
  # NOTE: not needed when containerized
  # FileUtils.rm_rf(instance_dir)
end
