import Bool "mo:base/Bool";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Map "mo:base/HashMap";
import Float "mo:base/Float";
import List "mo:base/List";

actor CurrencyRate {

  func natHash(n : Nat) : Hash.Hash {
    Text.hash(Nat.toText(n));
  };
  type Currency = {
    code : Text;
    rates : [Rate];
  };

  type Rate = {
    date : Text;
    value : Nat;
  };

  func generateRandomRates() : [Rate] {
    var resultList : [Rate] = [];

    for (i in 0..30) {
      let currentDate = Date.addDays(Date.localNow(), -i);
      let randomValue = Random.float(2000.0, 32000.0);
      let yearText = Nat.toText(Date.year(currentDate));
      let monthText = Nat.toText(Date.month(currentDate));
      let dayText = Nat.toText(Date.day(currentDate));
      let dateStr = yearText # "-" # monthText # "-" # dayText;

      let rateItem : Rate = {
        date = dateStr;
        value = randomValue;
      };
      //List.push(rateItem);
      resultList := resultList # [rateItem];
    };

    return resultList;
  };

  var currencyList = Map.HashMap<Nat, Currency>(0, Nat.equal, natHash);
  var nextId : Nat = 1;

  public query func getCurrencyList() : async [Currency] {
    return Iter.toArray(currencyList.vals(()));
  };

  public func addCurrency(code : Text) : async Nat {
    let id = nextId;
    let randomPriceList = generateRandomRates();
    currencyList.put(id, { code = code; rates = randomPriceList });
    nextId += 1;
    return id;
  };

  public query func showCurrencyList() : async Text {
    var output : Text = "\n_______To-Do-List______\n";
    
    for (currencyRate : CurrencyRate in currencyList.vals()) {
      output #= "\n" #currencyRate.Code;
    };

    return output # "\n";
  };

  public query func greet(name : Text) : async Text {
    return "Hello, " # name # "!";
  };

};
