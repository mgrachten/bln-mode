# `bln-mode`: A minor mode for binary line navigation in Emacs

# Introduction and Usage

Navigating the cursor across long lines of text by keyboard in Emacs can be
cumbersome, since commands like `forward-char`, `backward-char`, `forward-word`,
and `backward-word` move the cursor linearly, and potentially require a lot of
repeated executions to arrive at the desired position. `bln-mode` addresses this
issue. It defines the commands `bln-forward-half` and `bln-backward-half` that allow for
navigating from any position in a line to any other position in that line by
recursive binary subdivision.

For instance, if the cursor is at position K, invoking `bln-backward-half` will move
the cursor to position K/2. Successively invoking `bln-forward-half` will move the
cursor to K/2 + K/4, whereas a second invocation of `bln-backward-half` would move
the cursor to K/2 - K/4.

Below is an illustration of how you can use binary line navigation to reach
character `e` at column 10 from character `b` at column 34 in four steps:

                     +----------------+       bln-backward-half
                     |
            +--------+                        bln-backward-half
            |
            +---+                             bln-forward-half
                |
              +-+                             bln-backward-half
              |
    ..........e.......................b.....

This approach requires at most log(N) invocations to move from any position to
any other position in a line of N characters. Note that when you move in the
wrong direction---by mistakenly invoking `bln-backward-half` instead of
`bln-forward-half` or vice versa---you can interrupt the current binary navigation
sequence by moving the cursor away from its current position (for example, by
`forward-char`). You can then start the binary navigation again from that cursor
position.

# Installation

## Install the ELPA package from MELPA

    M-x package-install bln-mode
 
## Download and install with package.el manually

Download the HEAD of repository and install with:

    M-x package-install-file.


# Keybindings

The default keybindings are as follows:

| Command               | Key       |
| --------------------- | --------- |
| `bln-backward-half`   | *C-c . j* | 
| `bln-forward-half`    | *C-c . k* | 
| `bln-backward-half-v` | *C-c , j* | 
| `bln-forward-half-v`  | *C-c , k* | 
| `bln-backward-half-b` | *C-c . h* | 
| `bln-forward-half-b`  | *C-c . l* | 

Navigation using thse keybindings is rather cumbersome
however. Using the `hydra` package, the following bindings
provide a much more convenient interface:

```lisp
(defhydra hydra-bln ()
  "Binary line navigation mode"
  ("j" bln-backward-half "Backward in line")
  ("k" bln-forward-half "Forward in line")
  ("u" bln-backward-half-v "Backward in window")
  ("i" bln-forward-half-v "Forward in window")
  ("h" bln-backward-half-b "Backward in buffer")
  ("l" bln-forward-half-b "Forward in buffer"))
(define-key bln-mode-map (kbd "M-j") ’hydra-bln/body)
```

In this setup you press *M-j* to start the navigation, and press any
sequence of *j*, *k*, *u*, *i*, *h*, *l* to navigate. Any other key
will terminate the navigation.
