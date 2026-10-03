
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |memof/ |quaternion/ |lagopus/
      :type-slots $ {}
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn comp-container (store)
            group nil (memof1-call comp-tabs)
              case-default (:tab store) (group nil)
                :cube $ comp-cube
          :examples $ []
          :schema $ :: 'Dynamic
        'comp-cube $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn comp-cube ()
            object $ {} (:shader cube-wgsl)
              :topology $ do :line-strip :triangle-list
              :attrs-list $ [] $ {} (:field :position) (:format |float32x3)
              :data $ []
                {} $ :position $ [] 0 0 0
                {} $ :position $ [] 0 100 0
                {} $ :position $ [] 0 100 100
                {} $ :position $ [] 0 0 100
                {} $ :position $ [] 100 0 0
                {} $ :position $ [] 100 100 0
                {} $ :position $ [] 100 100 100
                {} $ :position $ [] 100 0 100
              :indices $ [] ([] 0 1 2 0 2 3) ([] 0 1 5 0 4 5) ([] 1 2 6 1 6 5) ([] 2 3 6 3 6 7) ([] 0 3 4 3 4 7) ([] 4 5 6 4 6 7)
          :examples $ []
          :schema $ :: 'Dynamic
        'comp-tabs $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn comp-tabs ()
            group nil
              comp-button
                {}
                  :position $ v3 0 200 0
                  :color $ [] 0.3 0.9 0.2 1
                  :size 20
                fn (e d!)
                  d! $ :: :tab :cube
              comp-button
                {}
                  :position $ v3 40 200 0
                  :color $ [] 0.8 0.3 1 1
                  :size 20
                fn (e d!)
                  d! $ :: :tab :todo
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require
            lagopus.alias :refer $ group object
            |../shaders/cube.wgsl :default cube-wgsl
            lagopus.comp.button :refer $ comp-button
            lagopus.comp.curves :refer $ comp-curves
            lagopus.comp.spots :refer $ comp-spots
            memof.once :refer $ memof1-call
            quaternion.core :refer $ c+
            quaternion.vector :refer $ v3
    'app.config $ %{} 'FileEntry
      :defs $ {} $ 'dev?
        %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            &= |dev $ get-env |mode |release
          :examples $ []
          :schema $ :: 'Bool
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defatom *store
            {} $ :tab :cube
          :examples $ []
          :schema $ :: 'Ref $ :: 'Map 'Tag 'Dynamic
        'canvas $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def canvas (js/document.querySelector |canvas)
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Dynamic
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            if dev? $ js/console.log op
            let
                store @*store
                next-store $ match op
                  (:states cursor s) (update-states store cursor s)
                  (:tab t) (assoc store :tab t)
                  _ $ do (eprintln ":unknown op" op) store
              if (not= next-store store) (reset! *store next-store)
            , &unit
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Enum
            :features $ #{} :js-ffi
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            if dev? $ load-console-formatter!
            js-await $ initializeContext
            initializeCanvasTextures
            reset-clear-color! $ either bg-color $ {} (:r 0.18) (:g 0.2) (:b 0.36) (:a 1)
            render-app!
            renderControl
            startControlLoop 10 onControlEvent
            set! js/window.__lagopusHandleCompilationInfo handle-compilation
            set! js/window.onresize $ fn (e) (resetCanvasSize canvas) (initializeCanvasTextures) (paintLagopusTree)
            resetCanvasSize canvas
            add-watch! *store :change $ fn (next store)
              hint-fn $ {}
                :args $ [] (:: 'Map 'Tag 'Dynamic) (:: 'Map 'Tag 'Dynamic)
                :return 'Unit
              render-app!
              , &unit
            setupMouseEvents canvas
            , &unit
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:async true) (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (nil? build-errors)
              do (reset-memof1-caches!) (render-app!) (remove-watch! *store :change)
                add-watch! *store :change $ fn (next store)
                  hint-fn $ {}
                    :args $ [] (:: 'Map 'Tag 'Dynamic) (:: 'Map 'Tag 'Dynamic)
                    :return 'Unit
                  render-app!
                  , &unit
                println |Reloaded.
                hud! |ok~ |OK
              hud! |error build-errors
            , &unit
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            let
                tree $ comp-container @*store
              renderLagopusTree tree dispatch!
          :examples $ []
          :ffi $ {} (:backend :js) (:target :browser)
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            app.comp.container :refer $ comp-container
            |@triadica/lagopus :refer $ setupMouseEvents onControlEvent paintLagopusTree renderLagopusTree initializeContext resetCanvasSize initializeCanvasTextures
            |@triadica/touch-control :refer $ renderControl startControlLoop
            app.config :refer $ dev?
            |bottom-tip :default hud!
            |./calcit.build-errors :default build-errors
            memof.once :refer $ reset-memof1-caches!
            lagopus.util :refer $ handle-compilation reset-clear-color!
            lagopus.cursor :refer $ update-states
            lagopus.config :refer $ bg-color
