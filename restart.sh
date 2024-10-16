#!/bin/bash
nvim_pid=$(pgrep nvim)
kill $nvim_pid
nvim &
