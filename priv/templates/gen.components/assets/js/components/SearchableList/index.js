class SearchableList extends HTMLElement {
    connectedCallback() {
        const $this = this
        this.searchInput = this.querySelector('[data-searchable-list-input]')
        this.visibleListElementDisplay = listElements(this) > 0 ? listElements(this).item(0).style.display : 'block'

        this.focusSearch = () => focusSearch($this)

        this.searchInput.addEventListener('keydown', e => {
            if (['Esc', 'Escape'].includes(e.key)) {
                $this.searchInput.value = ''
                updateList($this)
            }
        })

        this.searchInput.addEventListener('input', e => {
            e.stopPropagation()
            updateList($this)
        })

        this.searchInput.addEventListener('blur', e => e.stopPropagation())
        this.searchInput.addEventListener('focusout', e => e.stopPropagation())
        this.searchInput.addEventListener('change', e => e.stopPropagation())
    }
}

const listElements = (el) => el.querySelectorAll('[data-searchable-list-item]')

const matches = (query, value) => {
    return new RegExp(query, 'i').test(value)
}

const updateList = (el) => {
    const query = el.searchInput.value

    listElements(el).forEach(element => {
        element.style.display = matches(query, element.textContent) ? el.visibleListElementDisplay : 'none';
    });
}

const focusSearch = (el) => {
    el.searchInput.focus()
}

class SearchableListItem extends HTMLLIElement { }

window.customElements.define('custom-searchable-list', SearchableList)
window.customElements.define('custom-searchable-list-item', SearchableListItem, { extends: 'li' })
