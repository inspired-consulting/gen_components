class Autofocus extends HTMLElement {
  connectedCallback() {
    try {
      const element = this.querySelector('[autofocus]')
      if (element) element.select()
    } catch (error) {
      console.error(error)
    }
  }
}

window.customElements.define('custom-autofocus', Autofocus)
