class LocalDate extends HTMLElement {
  static get observedAttributes () {
    return ['iso-date']
  }

  attributeChangedCallback (name, oldValue, newValue) {
    (({
      'iso-date': (newValue) => {
        this.innerHTML = new Date(newValue).toLocaleDateString()
      }
    })[name])(newValue)
  }
}

window.customElements.define('custom-local-date', LocalDate)
