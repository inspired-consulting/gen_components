
// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"

// to activate local format custom components
import "./components"
import * as UpChunk from "@mux/upchunk"

let Uploaders = {}

Uploaders.UpChunk = function (entries, onViewError) {
    entries.forEach(entry => {

        // create the upload session with UpChunk
        let { file, meta: { entrypoint } } = entry

        // https://github.com/muxinc/upchunk
        let upload = UpChunk.createUpload({ endpoint: entrypoint, file, method: "POST" })

        // stop uploading in the event of a view error
        onViewError(() => upload.pause())

        // upload error triggers LiveView error
        upload.on("error", (e) => entry.error(e.detail.message))

        // notify progress events to LiveView
        upload.on("progress", (e) => {
            if (e.detail < 100) { entry.progress(e.detail) }
        })

        // success completes the UploadEntry
        upload.on("success", () => entry.progress(100))
    })
}


let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
    uploaders: Uploaders,
    params: { _csrf_token: csrfToken }
})

// connect if there are any LiveViews on the page
liveSocket.connect()


// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

