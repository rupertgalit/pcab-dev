export default class elEvent {
	constructor(identifier) {
		this.element = document.querySelector(identifier);
	}

	async click(evt) {
		this.element.addEventListener("click", evt);
	}

	async change(evt) {
		this.element.addEventListener("change", evt);
	}

	async submit(evt) {
		this.element.addEventListener("submit", evt);
	}

	updateInnerText(str) {
		this.element.textContent = str;
	}

	getInnerText() {
		return this.element.textContent;
	}

	replaceClass(_class, value) {
		const to_replace =
			typeof _class == "number" ? this.element.classList[_class] : _class;
		return this.element.classList.replace(to_replace, value);
	}

	getDetails() {
		return this.element;
	}
}
