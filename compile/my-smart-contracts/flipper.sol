contract flipper {
	bool private value;

	constructor(bool initvalue) {
		value = initvalue;
	}
	function flip() public {
		value = !value;
	}

	function get() public view returns (bool) {
		return value;
	}
}