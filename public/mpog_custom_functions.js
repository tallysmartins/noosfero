Array.prototype.removeValue = function(value) {
  for (var i = 0; i < this.length; i++) {
    if (this[i] === value) {
      this.splice(i, 1);
      i--;
    }
  }

  return this;
}

Array.prototype.removeIndex = function(index) {
  this.splice(index, 1);

  return this;
}
