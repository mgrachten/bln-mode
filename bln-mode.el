;;; bln-mode.el --- package providing binary line navigation minor-mode -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Maarten Grachten

;; Author: Maarten Grachten
;; Keywords: lisp
;; Version: 1.0

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; Navigating the cursor across long lines of text by keyboard in Emacs can be
;; cumbersome, since commands like `forward-char', `backward-char',
;; `forward-word', and `backward-word' move sequentially, and potentially
;; require a lot of repeated executions to arrive at the desired position. This
;; package provides the binary line navigation minor-mode (`bln-mode'), to
;; address this issue. It defines the commands `forward-half' and
;; `backward-half', which allow for navigating from any position in a line to
;; any other position in that line by recursive binary subdivision.

;; For instance, if the cursor is at position K, invoking `backward-half' will
;; move the cursor to position K/2. Successively invoking `forward-half'
;; (without moving the cursor in between invocations) will move the cursor to
;; K/2 + K/4, whereas a second invocation of `backward-half' would move the
;; cursor to K/2 - K/4.

;; Below is an illustration of how you can use binary line navigation to reach
;; character `e' at column 10 from character `b' at column 34 in four steps:
;;
;;                   ________________|     `backward-half'
;;          ________|                      `backward-half'
;;         |___                            `forward-half'
;;            _|                           `backward-half'
;; ..........e.......................b.....
;;
;; This approach requires at most log(N) invocations to move from any position
;; to any other position in a line of N characters. Note that when you move in
;; the wrong direction---by mistakenly invoking `backward-half' instead of
;; `forward-half' or vice versa---you can interrupt the current binary
;; navigation sequence by moving the cursor away from its current position (for
;; example, by `forward-char'). You can then start the binary navigation again
;; from that cursor position.

;; By default the commands `backward-half' and `forward-half' are bound to M-[
;; and M-], respectively.

;;; Code:

(let ((beg -1)
      (end -1)
      (prev-mid -1))
  
  (defun backward-half ()
    "This function is used in combination with `forward-half' to
provide binary line navigation (see `bln-mode')"
    (interactive)
    (if (/= prev-mid (point)) 
	(setq beg -1 end -1)
      (setq end prev-mid))
    (if (< beg 0) (setq beg (line-beginning-position)
			end (point)))
    (setq prev-mid (/ (+ beg end) 2))
    (goto-char prev-mid))
  
  (defun forward-half ()
    "This function is used in combination with `backward-half' to
provide binary line navigation (see `bln-mode')"
    (interactive)
    (if (/= prev-mid (point))
	(setq beg -1 end -1)
      (setq beg prev-mid))
    (if (< end 0) (setq beg (point)
			end (line-end-position)))
    (setq prev-mid (/ (+ beg end ) 2))
    (goto-char prev-mid))
  )

(defvar bln-mode-map (make-sparse-keymap) "bln-mode keymap")
(define-key bln-mode-map (kbd "M-]") 'forward-half)
(define-key bln-mode-map (kbd "M-[") 'backward-half)

(define-minor-mode bln-mode
  "Toggle binary line navigation mode.

Interactively with no argument, this command toggles the mode. A
positive prefix argument enables the mode, any other prefix
argument disables it. From Lisp, argument omitted or nil enables
the mode, `toggle' toggles the state.

Navigating the cursor across long lines of text by keyboard in
Emacs can be cumbersome, since commands like `forward-char',
`backward-char', `forward-word', and `backward-word' move the
cursor linearly, and potentially require a lot of repeated
executions to arrive at the desired position. `bln-mode'
addresses this issue. It defines the commands `forward-half' and
`backward-half' that allow for navigating from any position in a
line to any other position in that line by recursive binary
subdivision.

For instance, if the cursor is at position K, invoking
`backward-half' will move the cursor to position
K/2. Successively invoking `forward-half' will move the cursor to
K/2 + K/4, whereas a second invocation of `backward-half' would
move the cursor to K/2 - K/4.

Below is an illustration of how you can use binary line navigation
to reach character `e' at column 10 from character `b' at column
34 in four steps:

                  ________________|     `backward-half'
         ________|                      `backward-half'
        |___                            `forward-half'
           _|                           `backward-half'
..........e.......................b.....

This approach requires at most log(N) invocations to move from
any position to any other position in a line of N
characters. Note that when you move in the wrong direction---by
mistakenly invoking `backward-half' instead of `forward-half' or
vice versa---you can interrupt the current binary navigation
sequence by moving the cursor away from its current position (for
example, by `forward-char'). You can then start the binary
navigation again from that cursor position.

By default the commands `backward-half' and `forward-half' are
bound to M-[ and M-], respectively.
"
  :lighter " bln"
  :global
  :keymap bln-mode-map
  :group 'bln
  )

