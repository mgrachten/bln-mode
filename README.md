# `bln-mode`: A minor mode for binary line navigation in Emacs

# Introduction and Usage

Navigating the cursor across long lines of text by keyboard in Emacs can be
cumbersome, since commands like `forward-char`, `backward-char`, `forward-word`,
and `backward-word` move the cursor linearly, and potentially require a lot of
repeated executions to arrive at the desired position. `bln-mode` addresses this
issue. It defines the commands `forward-half` and `backward-half` that allow for
navigating from any position in a line to any other position in that line by
recursive binary subdivision.

For instance, if the cursor is at position K, invoking `backward-half` will move
the cursor to position K/2. Successively invoking `forward-half` will move the
cursor to K/2 + K/4, whereas a second invocation of `backward-half` would move
the cursor to K/2 - K/4.

Below is an illustration of how you can use binary line navigation to reach
character `e` at column 10 from character `b` at column 34 in four steps:

                     +----------------+       backward-half
                     |
            +--------+                        backward-half
            |
            +---+                             forward-half
                |
              +-+                             backward-half
              |
    ..........e.......................b.....

This approach requires at most log(N) invocations to move from any position to
any other position in a line of N characters. Note that when you move in the
wrong direction---by mistakenly invoking `backward-half` instead of
`forward-half` or vice versa---you can interrupt the current binary navigation
sequence by moving the cursor away from its current position (for example, by
`forward-char`). You can then start the binary navigation again from that cursor
position.

# Installation

## Download and install with package.el manually

Download the HEAD of repository and install with:

    M-x package-install-file.


# Keybindings

By default the commands `backward-half` and `forward-half` are bound to M-[
and M-], respectively. Depending on your keyboard layout, these keys may not
be very convenient. For more convenient binary line navigation, you could
bind to more convenient keys, like M-j and M-k (at the expense of losing the
default bindings for `indent-new-comment-line`, and `kill-sentence`,
respectively):

    (global-set-key (kbd "M-j") 'backward-half)
    (global-set-key (kbd "M-k") 'forward-half)
