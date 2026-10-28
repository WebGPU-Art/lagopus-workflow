
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |memof/ |quaternion/ |lagopus/
      :type-slots $ {}
  :files $ {}
    'app.browser $ %{} 'FileEntry
      :defs $ {}
        'error-text $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn error-text (message) |
          :examples $ []
          :ffi $ {} (:target :browser)
            :js $ {} $ :inline "|(message) => String(message)"
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'JsObject
            :features $ #{} :js-ffi
        'show-status! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn show-status! (status message) &unit
          :examples $ []
          :ffi $ {} (:target :browser)
            :js $ {}
              :inline "|(status, message) => { tip.default(status, message); }"
              :modules $ {} $ :tip |bottom-tip
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'String 'String
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.browser
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn comp-container (store)
            group nil (memo-object comp-tabs)
              if
                = :cube $ .unwrap-or (get store :tab) nil
                comp-cube
                group nil
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'JsObject)
            :args $ [] $ :: 'Map 'Tag 'Dynamic
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
          :schema $ :: 'Fn $ {} (:return 'JsObject)
            :args $ []
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
          :schema $ :: 'Fn $ {} (:return 'JsObject)
            :args $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require
            lagopus.alias :refer $ group object memo-object
            |../shaders/cube.wgsl :default cube-wgsl
            lagopus.comp.button :refer $ comp-button
            quaternion.vector :refer $ v3
    'app.config $ %{} 'FileEntry
      :defs $ {} $ 'dev?
        %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $ .unwrap-or (get-env |mode) |release
          :examples $ []
          :schema $ :: 'Bool
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *store
            {} $ :tab :cube
          :examples $ []
          :schema $ :: 'Ref $ :: 'Map 'Tag 'Dynamic
        'canvas $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def canvas (browser/query-canvas!)
          :examples $ []
          :schema $ :: 'lagopus.browser/Canvas
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            if dev? $ println op
            let
                store @*store
                next-store $ match op
                  (:states cursor data)
                    if (list? cursor)
                      update-states store
                        .map cursor $ fn (part)
                          if (tag? part) part $ raise "|State cursor must be a list of tags"
                        , data
                      raise "|State cursor must be a list of tags"
                  (:tab tab)
                    if (tag? tab) (assoc store :tab tab) (raise "|Tab must be a tag")
                  _ $ do (eprintln "|Unknown operation" op) store
              if (not= next-store store) (reset! *store next-store)
              , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Enum
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            if dev? $ load-console-formatter!
            js-await $ gpu/initialize-device!
            runtime/initialize-textures!
            reset-clear-color! $ .unwrap-or bg-color $ :: :rgba 0.18 0.2 0.36 1
            render-app!
            runtime/start-controls!
            runtime/register-shader-result! handle-compilation
            browser/set-resize-handler! resize!
            runtime/reset-canvas! canvas
            add-watch! *store :change store-changed!
            runtime/setup-mouse! canvas
            runtime/paint!
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:async true) (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (js-nullish? build-errors)
              do (reset-memof1-caches!) (render-app!) (remove-watch! *store :change) (add-watch! *store :change store-changed!) (println |Reloaded.) (show-status! |ok~ |OK)
              show-status! |error $ app.browser/error-text build-errors
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            runtime/render-tree! (comp-container @*store) dispatch!
            runtime/paint!
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
        'resize! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn resize! (_event) (runtime/reset-canvas! canvas) (runtime/initialize-textures!) (runtime/paint!)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'JsObject
        'store-changed! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn store-changed! (_next _previous) (render-app!)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] (:: 'Map 'Tag 'Dynamic) (:: 'Map 'Tag 'Dynamic)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            app.comp.container :refer $ comp-container
            app.config :refer $ dev?
            |./calcit.build-errors :default build-errors
            memof.once :refer $ reset-memof1-caches!
            lagopus.util :refer $ handle-compilation reset-clear-color!
            lagopus.cursor :refer $ update-states
            lagopus.config :refer $ bg-color
            lagopus.gpu :as gpu
            lagopus.browser :as browser
            lagopus.runtime :as runtime
            app.browser :refer $ show-status!
