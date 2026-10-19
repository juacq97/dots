;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(add-to-list 'default-frame-alist '(alpha-background . 0.85))

;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:

(setq doom-font (font-spec :family "Monofur Nerd Font Mono" :size 18 :weight 'semi-bold))
(setq doom-variable-pitch-font (font-spec :family "Fira Sans" :size 14 :weight 'semi-bold))
(setq doom-big-font (font-spec :family "Fira Sans" :size 24 :weight 'semi-bold))
(setq doom-theme 'ef-cyprus)
(setq display-line-numbers-type 'relative)
(setq org-directory "~/org/")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(defun my/consult-baul-action (file)
  "Abre FILE en Emacs si es texto/código, o con la aplicación externa del sistema si es binario/multimedia."
  (let* ((ext (downcase (or (file-name-extension file) "")))
         ;; Lista de extensiones que quieres abrir dentro de Emacs (incluyendo "" para archivos sin extensión como LICENSE o Makefile)
         (text-exts '("el" "txt" "md" "org" "html" "css" "js" "json" "yaml" "yml" "sh" "typ" "py" "c" "cpp" "h" "ini" "cfg" "conf" "csv" "xml" "")))
    (if (member ext text-exts)
        (consult--file-action file)
      ;; Abre con la aplicación externa del sistema (equivalente a abrir con 'E' en Dired)
      (start-process "external-opener" nil "xdg-open" (expand-file-name file)))))

(defun my/consult-find-baul ()
  "Busca archivos de forma recursiva en ~/baul usando consult-find."
  (interactive)
  (let ((default-directory (expand-file-name "~/baul")))
    (consult-find)))

(defvar consult-source-baul
  `(:name     "Baul"
    :narrow   ?m                    ; Letra para filtrar con narrowing (ej: presionar b dentro de consult-buffer)
    :category file
    :face     consult-file
    :history  file-name-history
    :items    (lambda ()
                ;; Lista los archivos de forma recursiva en ~/baul
                (directory-files-recursively (expand-file-name "~/baul") "" nil t))
    :action   ,#'my/consult-baul-action)
  "Fuente personalizada para buscar archivos en el baúl dentro de consult-buffer.")

(defvar consult-source-xdg-apps
  `(:name "Apps"
    :narrow ?a
    :category app
    :items ,(lambda ()
              (mapcar #'car (ewm-list-xdg-apps)))
    :action ,#'ewm-launch-xdg-command))

(setq consult-buffer-sources
      '(consult-source-buffer
        consult-source-baul
        consult-source-hidden-buffer
        consult-source-modified-buffer
        consult-source-recent-file
        consult-source-xdg-apps
        ))

(defun my/ewm-frame-new-named ()
  "Pregunta un nombre, crea un frame y le asigna el nombre de forma segura."
  (interactive)
  ;; 1. Preguntamos el nombre primero
  (let ((frame-name (read-string "Nombre del nuevo frame (dejar en blanco para default): "))
        created-frame)

    ;; 2. Usamos un hook temporal para capturar el frame exacto que se va a crear
    (let ((hook (lambda (f) (setq created-frame f))))
      (add-hook 'after-make-frame-functions hook)
      (unwind-protect
          (ewm-frame-new)
        (remove-hook 'after-make-frame-functions hook)))

    ;; 3. Si se creó un frame y escribiste un nombre, se lo aplicamos directamente al objeto
    (when (and created-frame (not (string-empty-p frame-name)))
      (set-frame-parameter created-frame 'name frame-name))))


(use-package ewm
  :custom
  (ewm-output-config '(("eDP-1" :width 2256 :height 1504 :scale 1.5)))
  :bind (:map ewm-mode-map
              ("s-SPC" . consult-buffer)
              ("s-l" . windmove-right)
              ("s-h" . windmove-left)
              ("s-k" . windmove-up)
              ("s-j" . windmove-down)
              ("s-o" . split-window-right)
              ("s-i" . split-window-below)
              ("C-x b" . consult-buffer)
              ("s-t" . my/ewm-frame-new-named)
              ("s-r" . set-frame-name)
              ("s-q". ewm-frame-close)
              ("s-w" . select-frame-by-name)
              ("s-<f11>" . ewm-toggle-fullscreen)
              )
  :config
  (start-process-shell-command "awww-daemon" nil "awww-daemon")
  )

(setopt ewm-input-config
        '((touchpad :natural-scroll t :tap t :dwt t)
          (mouse :accel-profile "flat")
          (trackpoint :accel-speed 0.5)
          (keyboard :repeat-delay 200 :repeat-rate 25
                    :xkb-layouts "latam"
                    )))

;; Render unfocused windows at 70% opacity.

(when (daemonp)
  (add-hook 'after-make-frame-functions
            (defun +ewm-trigger-server-hooks-h (frame)
              (when (display-graphic-p frame)
                (remove-hook 'after-make-frame-functions #'+ewm-trigger-server-hooks-h)
                (with-selected-frame frame
                  (run-hooks 'server-after-make-frame-hook))))))

(map! "C-x b" #'consult-buffer)

;; COnfiguraaacion para usar tabbar como un status line
(use-package! i3bar
  :config
  (i3bar-mode 1))

(use-package! tab-bar
  :init
  (setq tab-bar-tab-name-function
        (lambda ()
          (or (frame-parameter nil 'name) "Frame sin nombre")))
  (setq tab-bar-close-button-show nil)
  :custom
  (tab-bar-format '(tab-bar-format-tabs        ; Optional: Remove to _only_ display the bar.
                    tab-bar-format-align-right ; Optional: Remove to align left.
                    tab-bar-format-global))
  :config
  (tab-bar-mode 1))

(use-package! kdeconnect
  :config
  (setq kdeconnect-devices '(("Pixel" . "9704b455f09f4accb767615b269c474f")))
  (setq kdeconnect-active-device '("Pixel" . "9704b455f09f4accb767615b269c474f"))
  )

(add-hook! 'doom-load-theme-hook
  (defun my/apply-tab-bar-styles ()
    (let ((bg (face-attribute 'tab-bar :background nil 'default)))
      (set-face-attribute 'tab-bar-tab nil :background bg :box nil :family "Fira Sans")
      (set-face-attribute 'tab-bar-tab-inactive nil :box nil :family "Fira Sans")
      (set-face-attribute 'tab-bar-tab-highlight nil :background bg :box nil :family "Fira Sans"))))

;;
;; (defun my/dired-last-active-dir ()
;;    { link = background" }el último directorio activo en la lista de buffers y devuelve un buffer de dired."
;;   (let ((last-dir
;;          (catch 'found
;;            ;; buffer-list devuelve los buffers ordenados por uso más reciente
;;            (dolist (buf (buffer-list))
;;              (with-current-buffer buf
;;                ;; Ignorar el dashboard y los buffers especiales (que empiezan con *)
;;                (when (and default-directory
;;                           (not (string-match-p "^\\s-*\\*" (buffer-name)))
;;                           (not (eq maj
;;                                    (throw 'found default-directory))))
;;                  ;; Fallback al home si por alguna razón no hay buffers activos
;;                  "~/")))
;;            (dired-noselect last-dir))))))
;; 
;; ;; Indicarle a Emacs que use esta función al abrir un nuevo frame sin argumentos
;; (setq initial-buffer-choice #'my/dired-last-active-dir)
;; 
(after! dired
  (map! :map dired-mode-map
        :ng "h" #'dired-up-directory
        :ng "l" #'dired-find-file))
;; 

(meow-define-keys
    'normal
  '("y" . meow-clipboard-save)
  )

(defun mi/run-in-quick-frame (command)
  "Abre un frame flotante minimalista, ejecuta COMMAND y cierra el frame al salir."
  (interactive)
  (let* ((frame (make-frame '((name . "emacs-quick-launcher")
                              (width . 90)
                              (height . 15)
                              (undecorated . t)
                              (visibility . visible)
                              (fullscreen . nil))))
         (cleanup (lambda ()
                    (when (frame-live-p frame)
                      (delete-frame frame)))))
    (select-frame frame)
    ;; Asegurarnos de que el frame se borre cuando el minibuffer termine o se cancele
    (add-hook 'minibuffer-exit-hook cleanup nil t)
    (unwind-protect
        (call-interactively command)
      ;; Por si acaso se sale sin pasar por el minibuffer-exit-hook normal
      (when (frame-live-p frame)
        (delete-frame frame)))))

;; Wrappers específicos para tus accesos directos
(defun mi/quick-M-x ()
  (interactive)
  (mi/run-in-quick-frame #'execute-extended-command))

(defun mi/quick-consult-buffer ()
  (interactive)
  (mi/run-in-quick-frame #'consult-buffer))


;; (use-package! mini-frame
;;   :config
;;   (mini-frame-mode 1)
;;   (setq mini-frame-standalone t))
