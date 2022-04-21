class LocalTime extends HTMLElement {
  format (name) {
    return ({
      medium: {},
      short: { hour: '2-digit', minute: '2-digit' }
    })[name]
  }

  constructor () {
    super()
    this._format = 'medium'
    this._date = null
  }

  _rerender () {
    this.innerHTML = new Date(this._date).toLocaleTimeString([], this.format(this._format))
  }

  static get observedAttributes () {
    return ['iso-time', 'format']
  }

  attributeChangedCallback (name, oldValue, newValue) {
    (({
      'iso-time': (newValue) => { this._date = newValue },
      'format': (newValue) => { this._format = newValue }
    })[name])(newValue)
    this._rerender()
  }
}

window.customElements.define('custom-local-time', LocalTime)
