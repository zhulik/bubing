#include <string>

class Data {
public:
    Data(const std::string &data);
    std::string data() const;

private:
    std::string m_data;

};