#include "data.h"

Data::Data(const std::string &data): m_data(data) {

}

std::string Data::data() const {
    return m_data;
}