#include "doctest.h"

#include <algorithm>
#include <format>
#include <functional>
#include <map>
#include <ranges>
#include <set>
#include <span>
#include <stdexcept>
#include <string>
#include <string_view>
#include <variant>
#include <vector>

// collections

TEST_CASE("a vector grows when you push onto it and a span views part of it without copying") {
  std::vector<int> values{1, 2, 3};

  values.push_back(4);
  std::span<int> window(values.begin() + 1, 2);

  CHECK(values.size() == 4);
  CHECK(values.at(3) == 4);
  CHECK(window.size() == 2);
  CHECK(window[0] == 2);
}

TEST_CASE("asking a map whether it holds a key is a different call from reading the value") {
  std::map<std::string, int> counts{{"a", 1}, {"b", 2}};

  bool present = counts.contains("a");
  auto missing = counts.find("z");

  CHECK(present);
  CHECK(counts.at("b") == 2);
  CHECK(missing == counts.end());
  CHECK(counts.size() == 2);
}

TEST_CASE("a set keeps one of each value and keeps them sorted") {
  std::set<int> values{3, 1, 2};

  auto inserted = values.insert(1);

  CHECK_FALSE(inserted.second);
  CHECK(values.size() == 3);
  CHECK(*values.begin() == 1);
  CHECK(values.contains(3));
}

// strings

TEST_CASE("splitting a string gives views of it and joining them back up builds a new one") {
  std::string text = "one two three";

  std::vector<std::string> parts;
  for (auto part : std::views::split(text, ' ')) {
    parts.emplace_back(std::string_view(part));
  }
  std::string joined;
  for (const std::string &part : parts) {
    joined += joined.empty() ? part : "-" + part;
  }

  CHECK(parts.size() == 3);
  CHECK(parts.at(1) == "two");
  CHECK(joined == "one-two-three");
}

TEST_CASE("a formatted string fills its placeholders in the order the arguments are given") {
  std::string label = "ab";
  int count = 2;

  std::string line = std::format("{} x{}", label, count);
  std::string padded = std::format("{:>5}", label);

  CHECK(line == "ab x2");
  CHECK(padded == "   ab");
  CHECK(std::string(3, 'a') == "aaa");
}

TEST_CASE("a substring is a copy and a string view is a window onto the original") {
  std::string text = "abcdef";

  std::string copied = text.substr(1, 3);
  std::string_view window(text);
  text[1] = 'B';

  CHECK(copied == "bcd");
  CHECK(window.substr(1, 3) == "Bcd");
  CHECK(text.front() == 'a');
  CHECK(text.size() == 6);
}

// types and branching

struct Point {
  int x;
  int y;

  bool operator==(const Point &) const = default;
};

TEST_CASE("a struct is copied on assignment and compares field by field") {
  Point record{.x = 1, .y = 2};

  Point moved = record;
  moved.x = 5;

  CHECK(record == Point{.x = 1, .y = 2});
  CHECK_FALSE(moved == record);
  CHECK(record.x == 1);
}

enum class Level { Low, Middle, High };

static std::string name_of(Level value) {
  switch (value) {
  case Level::Low:
    return "low";
  case Level::Middle:
    return "middle";
  case Level::High:
    return "high";
  }
  return "unknown";
}

TEST_CASE("a scoped enum orders its members but will not become an integer without a cast") {
  Level value = Level::Middle;

  std::string named = name_of(value);

  CHECK(named == "middle");
  CHECK(static_cast<int>(value) == 1);
  CHECK(value > Level::Low);
}

using Value = std::variant<int, std::string>;

static std::string describe(const Value &value) {
  struct Describer {
    std::string operator()(int held) const { return std::format("number {}", held); }
    std::string operator()(const std::string &held) const { return std::format("text {}", held); }
  };

  return std::visit(Describer{}, value);
}

TEST_CASE("a variant holds one of its types at a time and visiting it must cover them all") {
  Value number = 7;
  Value text = std::string("seven");

  CHECK(describe(number) == "number 7");
  CHECK(describe(text) == "text seven");
  CHECK(number.index() == 0);
  CHECK(std::get_if<std::string>(&number) == nullptr);
}

// iteration

TEST_CASE("a range based loop hands over each element and enumerate adds the index") {
  std::vector<std::string> items{"a", "b"};

  std::string seen;
  for (auto [index, item] : std::views::enumerate(items)) {
    seen += std::format("{}:{}", index, item);
  }

  CHECK(seen == "0:a1:b");
}

TEST_CASE("walking a sequence with lookahead gives one window fewer than there are elements") {
  std::vector<int> values{1, 2, 3, 4};

  std::vector<int> sums;
  for (auto [left, right] : values | std::views::adjacent<2>) {
    sums.push_back(left + right);
  }

  CHECK(sums.size() == 3);
  CHECK(sums.front() == 3);
  CHECK(sums.back() == 7);
}

// functions

static int negated(int value) { return -value; }

static std::vector<int> map_over(const std::vector<int> &values,
                                 const std::function<int(int)> &apply) {
  std::vector<int> out;
  std::ranges::transform(values, std::back_inserter(out), apply);
  return out;
}

TEST_CASE("a function taking a callable accepts a lambda and a named function alike") {
  std::vector<int> values{1, 2, 3};

  std::vector<int> doubled = map_over(values, [](int value) { return value * 2; });
  std::vector<int> negatives = map_over(values, negated);

  CHECK(doubled == std::vector<int>{2, 4, 6});
  CHECK(negatives.back() == -3);
}

TEST_CASE("folding a sequence to one value takes a starting value and a combining function") {
  std::vector<int> values{1, 2, 3, 4};

  int total = std::ranges::fold_left(values, 0, std::plus{});
  int largest =
      std::ranges::fold_left(values, 0, [](int best, int value) { return std::max(best, value); });

  CHECK(total == 10);
  CHECK(largest == 4);
  CHECK(std::ranges::fold_left(std::vector<int>{}, 0, std::plus{}) == 0);
}

// errors

class OutOfRange : public std::runtime_error {
public:
  explicit OutOfRange(int value)
      : std::runtime_error(std::format("{} is outside 0 to 100", value)) {}
};

static int checked_percentage(int value) {
  if (value < 0 || value > 100) {
    throw OutOfRange(value);
  }
  return value;
}

struct Guard {
  bool &released;

  ~Guard() { released = true; }
};

TEST_CASE("a refusal is a thrown exception and destructors still run as it unwinds") {
  bool released = false;

  auto attempt = [&released] {
    Guard guard{released};
    return checked_percentage(140);
  };

  CHECK_THROWS_AS(attempt(), OutOfRange);
  CHECK_THROWS_WITH(checked_percentage(-1), "-1 is outside 0 to 100");
  CHECK(released);
  CHECK(checked_percentage(40) == 40);
}

// gotchas

TEST_CASE("reading a missing key out of a map with square brackets inserts it") {
  std::map<std::string, int> counts{{"a", 1}};

  int read = counts["b"];

  CHECK(read == 0);
  CHECK(counts.size() == 2);
  CHECK(counts.contains("b"));
  CHECK_THROWS_AS(counts.at("c"), std::out_of_range);
}
