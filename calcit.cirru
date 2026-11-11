
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
          :schema $ quote $ Fn JsObject (-> String) (:features :js-ffi)
        'show-status! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn show-status! (status message) &unit
          :examples $ []
          :ffi $ {} (:target :browser)
            :js $ {}
              :inline "|(status, message) => { tip.default(status, message); }"
              :modules $ {} $ :tip |bottom-tip
          :schema $ quote $ Fn String String (-> Unit) (:features :js-ffi)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.browser
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'SceneTab $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum SceneTab (:cube) (:todo)
          :examples $ []
          :schema $ quote EnumDef
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn comp-container (tab)
            group nil (memo-object comp-tabs)
              match tab
                (:cube) (comp-cube)
                (:todo) (group nil)
          :examples $ []
          :schema $ quote $ Fn SceneTab (-> JsObject)
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
          :schema $ quote $ Fn (-> JsObject)
        'comp-tabs $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn comp-tabs ()
            group nil
              comp-button
                {}
                  :position $ v3 0 200 0
                  :color $ [] 0.3 0.9 0.2 1
                  :size 20
                fn (e d!)
                  hint-fn $ Fn JsObject
                    Fn app.comp.container/SceneTab $ -> Unit
                    -> Unit
                  d! $ SceneTab :cube
              comp-button
                {}
                  :position $ v3 40 200 0
                  :color $ [] 0.8 0.3 1 1
                  :size 20
                fn (e d!)
                  hint-fn $ Fn JsObject
                    Fn app.comp.container/SceneTab $ -> Unit
                    -> Unit
                  d! $ SceneTab :todo
          :examples $ []
          :schema $ quote $ Fn (-> JsObject)
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
          :schema $ quote Bool
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *store (app.comp.container/SceneTab :cube)
          :examples $ []
          :schema $ quote $ Ref app.comp.container/SceneTab
        'canvas $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def canvas (browser/query-canvas!)
          :examples $ []
          :schema $ quote browser/Canvas
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (tab)
            if dev? $ println tab
            when (not= tab @*store) (reset! *store tab)
            , &unit
          :examples $ []
          :schema $ quote $ Fn app.comp.container/SceneTab (-> Unit)
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            if dev? $ load-console-formatter!
            js-await $ gpu/initialize-device!
            runtime/initialize-textures!
            reset-clear-color! $ .unwrap-or bg-color $ lagopus.config/ClearColor :rgba 0.18 0.2 0.36 1
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
          :schema $ quote $ Fn (-> Unit) (:features :js-ffi) (:async)
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (js-nullish? build-errors)
              do (reset-memof1-caches!) (render-app!) (remove-watch! *store :change) (add-watch! *store :change store-changed!) (println |Reloaded.) (show-status! |ok~ |OK)
              show-status! |error $ app.browser/error-text build-errors
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :js-ffi)
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            runtime/render-tree! (comp-container @*store) dispatch!
            runtime/paint!
          :examples $ []
          :schema $ quote $ Fn (-> Unit)
        'resize! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn resize! (_event) (runtime/reset-canvas! canvas) (runtime/initialize-textures!) (runtime/paint!)
          :examples $ []
          :schema $ quote $ Fn JsObject (-> Unit)
        'store-changed! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn store-changed! (_next _previous) (render-app!)
          :examples $ []
          :schema $ quote $ Fn app.comp.container/SceneTab app.comp.container/SceneTab (-> Unit)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            app.comp.container :refer $ comp-container
            app.config :refer $ dev?
            |./calcit.build-errors :default build-errors
            memof.once :refer $ reset-memof1-caches!
            lagopus.util :refer $ handle-compilation reset-clear-color!
            lagopus.config :refer $ bg-color
            lagopus.gpu :as gpu
            lagopus.browser :as browser
            lagopus.runtime :as runtime
            app.browser :refer $ show-status!
