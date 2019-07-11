;;; poly-kallychore.el --- Basic polymode for kallychore text / shell scripts
;;
;; Author: Evans Winner
;; Copyright (C) 2019 Evans Winner
;; Version: 1
;; Keywords: languages, multi-modes
;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This file is *NOT* part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

(require 'polymode)

(define-hostmode poly-kallychore-hostmode
  :mode 'text-mode)

(define-innermode poly-kallychore-innermode
  :mode 'shell-script-mode
  :head-matcher "^{{{\n"
  :tail-matcher "^}}}\n"
  :head-mode 'host
  :tail-mode 'host)

(define-polymode poly-kallychore-mode
  :hostmode 'poly-kallychore-hostmode
  :innermodes '(poly-kallychore-innermode))

(provide 'poly-kallychore)
