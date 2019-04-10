#include <iostream>
#include "mbed.h"
using namespace std;
template <class  T>
class BinaryType
{
	private:
		T val;
		uint8_t Nbits;
	public:
	BinaryType(T value) {
		val = value;
		Nbits = 8 * sizeof(T);
	}
	void display() {
		for (uint8_t n=0, b=Nbits-1; n < Nbits; n++, b--) 
		{
				if (val & (1 << b)) {
					cout << "1";
				} else {
					cout << "0";
				}
		}
	}
	uint8_t bit(uint8_t b) {
		return (1 << b) & val ? 1 : 0;
	}
	
	void operator =(T newVal) {
			this->val = newVal;
	}
};
