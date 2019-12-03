import 'dart:math';

class Deck extends Card
{
  List<Card> cards;

  Deck({this.cards});

  // function to make a new full deck
  Deck newDeckFull()
  {

    Card current;
    String s;
    String num;
    Deck temp = Deck(
      cards: [],
    );


    for(int i = 1; i < 14; i++)
    {

      switch(i)
      {
        case 1:{num = "A";}
        break;
        case 2:{num = "2";}
        break;
        case 3:{num = "3";}
        break;
        case 4:{num = "4";}
        break;
        case 5:{num = "5";}
        break;
        case 6:{num = "6";}
        break;
        case 7:{num = "7";}
        break;
        case 8:{num = "8";}
        break;
        case 9:{num = "9";}
        break;
        case 10:{num = "10";}
        break;
        case 11:{num = "J";}
        break;
        case 12:{num = "Q";}
        break;
        case 13:{num = "K";}
        break;
      }

      for(int j = 0; j < 4; j++)
      {
        switch(j)
        {
          case 0:{s = "♥";}
          break;
          case 1:{s = "♦";}
          break;
          case 2:{s = "♣";}
          break;
          case 3:{s = "♠";}
        }


        current = newCard(s,num);
        temp.cards.add(current);

      }
    }

    return temp;
  }

  /* function to return a hand's score. works with THE and FCD.
     the score is in base 13, with the highest digits in the number used for
     the hand's high cards. for example, two straight flushes, but one's highest
     card is an 8, while the other is a 7. the SF with an 8 would win.*/
  int Score(Deck hand)
  {
    bool flush = isFlush(hand, 0, hand.cards.length);
    bool straight = isStraight(hand);

    if(flush && straight)
      {
        if(isSF(hand))
          {
            print("Somehow, Straight Flush. Nice");
            return getSF(hand) * pow(13, 12);
          }
      }

    bool pair = isPair(hand);
    bool threekind;

    if(pair) {
      threekind = isThreeKind(hand);
      if(threekind)
      {
        bool fourkind = is4k(hand);
        bool fullhouse = isFH(hand, getThreeKind(hand));
        if(fourkind)
          {
            return get4k(hand) * pow(13, 11);
          }
        else if(fullhouse)
        {
          print("Full House");
          return (getThreeKind(hand)-1) * pow(13,10);
        }
      }
    }

    if(flush)
      {
        print("Flush");
        return getFlush(hand) * pow(13, 5);
      }
    if(straight)
      {
        print("Straight");
        return getStraight(hand) * pow(13, 8);
      }

    if(pair)
      {
        if(threekind)
          {
            print("Three Kind");
            return (getThreeKind(hand)-1) + pow(13,7);
          }
        else if(is2Pair(hand))
          {
            print("Two Pair");
            return getHighPair(hand) * pow(13,5) + getPair(hand) * pow(13, 6) + get2PairHigh(hand) * pow(13, 4);
          }
         else
          {
            print("Pair");
            return getPair(hand) * pow(13, 5) + getPairHighs(hand) * pow(13, 2);
          }

      }

    print("High Card");
    return getHighCard(hand);




  }

  bool isSF(Deck hand)
  {
    Deck temp = hand.sortByRank(hand);

    print("Temp: ");

    for(int i = 0; i < temp.cards.length; i++)
    {
      print(temp.cards[i].number + temp.cards[i].suit);
    }

    // checking if for an A2345 flush. im sure there's a neater way to do this, but i can't be bothered

    for(int i = 0; i < temp.cards.length-4; i++)
    {
      if(temp.cards[i].number == 'A')
      {
        for(int j = i+1; j > temp.cards.length-3; j++)
        {
          if(temp.cards[j].number == '5' && temp.cards[i].suit == temp.cards[j].suit)
          {
            for(int j2 = j+1; j2 > temp.cards.length-2; j2++)
            {
              if (temp.cards[j2].number == '4' &&
                  temp.cards[i].suit == temp.cards[j2].suit)
              {
                for (int j3 = j2 + 1; j3 > temp.cards.length - 1; j3++)
                {
                  if (temp.cards[j3].number == '3' &&
                      temp.cards[i].suit == temp.cards[j3].suit)
                  {
                    for (int j4 = j3 + 1; j4 > temp.cards.length; j4++)
                    {
                      if (temp.cards[j4].number == '2' &&
                          temp.cards[i].suit == temp.cards[j4].suit)
                      {
                        return true;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    temp = sortBySuit(temp);



    for(int i = 0; i < temp.cards.length - 4; i++)
    {

        if(hand.cards[i+4].numberRank(hand.cards[i+4].number) == hand.cards[i].numberRank(hand.cards[i].number)-4)
        {
          return true;
        }

    }

    return false;
  }

  bool is4k(Deck hand)
  {
    Deck temp = hand.sortByRank(hand);

    for(int i = 0; i<temp.cards.length-3; i++)
      {
        if(temp.cards[i].number == temp.cards[i+1].number)
          {
            if(temp.cards[i].number == temp.cards[i+2].number && temp.cards[i].number == temp.cards[i+3].number)
              {
                return true;
              }
          }
      }
    return false;
  }

  bool isFH(Deck hand, int threek)
  {
    Deck temp = hand.sortByRank(hand);

    for(int i = 0; i < temp.cards.length-1; i++)
    {
      if(temp.cards[i].numberRank(temp.cards[i].number) != threek)
        {
          if(temp.cards[i].number == temp.cards[i+1].number)
            {
              return true;
            }
        }
    }
    return false;
  }

  bool isFlush(Deck hand, int lower, int upper)
  {

    List<int> soots = [0,0,0,0]; // (♥, ♦, ♣, ♠)
    for(int i = lower; i < upper; i++)
      {
        switch(hand.cards[i].suit)
        {
          case '♥':{soots[0]++;}
          break;
          case '♦':{soots[1]++;}
          break;
          case '♣':{soots[2]++;}
          break;
          case '♠':{soots[3]++;}
        }
      }

    for(int i = 0; i < 4; i++)
      {
        //print("${soots[i]}");
        if(soots[i] >= 5)
          {
            return true;
          }
      }

    return false;
  }

  bool isStraight(Deck hand)
  {
    Deck temp = sortByRank(hand);

    // checking for A2345 straight
    for(int i = 0; i < temp.cards.length-4; i++)
    {
      if(temp.cards[i].number == 'A')
      {
        for(int j = i+1; j > temp.cards.length-3; j++)
        {
          if(temp.cards[j].number == '5')
          {
            for(int j2 = j+1; j2 > temp.cards.length-2; j2++)
            {
              if (temp.cards[j2].number == '4')
              {
                for (int j3 = j2 + 1; j3 > temp.cards.length - 1; j3++)
                {
                  if (temp.cards[j3].number == '3')
                  {
                    for (int j4 = j3 + 1; j4 > temp.cards.length; j4++)
                    {
                      if (temp.cards[j4].number == '2')
                      {
                        return true;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    for(int i = 0; i < temp.cards.length - 4; i++)
      {
        int k = 4;
        int straightcheck = 0;
       for(int j = 0; j < k; j++)
         {
           // print("${temp.cards[j+i].numberRank(temp.cards[j+i].number)}     ${temp.cards[j+i+1].numberRank(temp.cards[j+i+1].number)}");

           if(temp.cards[i+j].numberRank(temp.cards[i+j].number) != temp.cards[j+i+1].numberRank(temp.cards[j+i+1].number)+1 && temp.cards[j+i].numberRank(temp.cards[j+i].number) != temp.cards[j+i+1].numberRank(temp.cards[j+i+1].number) )
             {
               j = k-1;
             }


           if(temp.cards[i+j].numberRank(temp.cards[i+j].number) == temp.cards[i+j+1].numberRank(temp.cards[i+j+1].number)+1)
           {
             straightcheck++;
           }
           if(temp.cards[i+j].numberRank(temp.cards[i+j].number) == temp.cards[i+j+1].numberRank(temp.cards[i+j+1].number))
           {
             k++;
             if(k + i >= temp.cards.length)
               {

                 j = k+1;
                 i = temp.cards.length;
               }
           }

           if(straightcheck == 4)
             {
               //print("ITS STRAIGHT");
               return true;
             }
         }
      }
    return false;
  }

  bool isThreeKind(Deck hand)
  {
    Deck temp = hand.sortByRank(hand);


    for(int i = 0; i < temp.cards.length-2; i++)
    {
      if(temp.cards[i].number == temp.cards[i+1].number && temp.cards[i].number == temp.cards[i+2].number )
      {
        return true;
      }
    }
    return false;
  }

  bool is2Pair(Deck hand)
  {
    Deck temp = hand.sortByRank(hand);

    for(int i = 0; i < temp.cards.length-3; i++)
    {
      if(temp.cards[i].number == temp.cards[i+1].number)
      {
        for(int j = i+2; j < temp.cards.length-1; j++)
        {
          if(temp.cards[j].number == temp.cards[j+1].number)
          {
            return true;
          }
        }
      }
    }

    return false;
  }

  bool isPair(Deck hand)
  {
    Deck temp = hand.sortByRank(hand);


    for(int i = 0; i < temp.cards.length-1; i++)
      {
        if(temp.cards[i].number == temp.cards[i+1].number)
          {
            return true;
          }
      }
    return false;

  }

  Deck sortByRank(Deck hand)
  {
    Deck temp = hand;
    Card swaphold;
    int high;

    for(int i = 0; i < hand.cards.length-1; i++)
      {
        high = highest(temp, i+1, temp.cards.length);
        if(temp.cards[i].numberRank(temp.cards[i].number) < temp.cards[high].numberRank(temp.cards[high].number))
          {
            swaphold = temp.cards[high];
            temp.cards[high] = temp.cards[i];
            temp.cards[i] = swaphold;
          }
      }

    return temp;

  }

  Deck sortBySuit(Deck hand)
  {
    Deck temp = hand.sortByRank(hand);
    Card swaphold;
    int high;

    for(int i = 0; i < temp.cards.length-1; i++)
    {
      for(int j = i+1; j < temp.cards.length; j++)
        {
          if(suitValue(temp.cards[i]) > suitValue(temp.cards[j]))
            {
              swaphold = temp.cards[j];
              temp.cards[j] = temp.cards[i];
              temp.cards[i] = swaphold;
            }
          if(temp.cards[i].suit == temp.cards[j].suit )
            {
              if(temp.cards[i].numberRank(temp.cards[i].number) < temp.cards[j].numberRank(temp.cards[j].number))
                {
                  swaphold = temp.cards[j];
                  temp.cards[j] = temp.cards[i];
                  temp.cards[i] = swaphold;
                  //print("SWAPPED: " + temp.cards[i].number + temp.cards[i].suit + " - " + temp.cards[j].number + temp.cards[j].suit);
                }
            }
        }
    }

    return temp;
  }

  int suitValue(Card card)
  {
    switch(card.suit)
    {
      case '♥':{return 0;}
      case '♦':{return 1;}
      case '♣':{return 2;}
      case '♠':{return 3;}
    }
    return -1;
  }

  int highest(Deck hand, int lower, int upper)
  {
    int high = 0;
    int index;
    for(int i = lower; i < upper; i++)
      {
        if(hand.cards[i].numberRank(hand.cards[i].number) > high)
        {
          high = hand.cards[i].numberRank(hand.cards[i].number);
          index = i;
        }
      }
    return index;
  }

  int getSF(Deck hand)
  {
    Deck temp = hand.sortByRank(hand);

    for(int i = 0; i < temp.cards.length-4; i++)
    {
        if(temp.cards[i].number == 'A')
        {
          for(int j = i+1; j > temp.cards.length-3; j++)
          {
            if(temp.cards[j].number == '5' && temp.cards[i].suit == temp.cards[j].suit)
            {
              for(int j2 = j+1; j2 > temp.cards.length-2; j2++)
              {
                if (temp.cards[j2].number == '4' &&
                    temp.cards[i].suit == temp.cards[j2].suit)
                {
                  for (int j3 = j2 + 1; j3 > temp.cards.length - 1; j3++)
                  {
                    if (temp.cards[j3].number == '3' &&
                        temp.cards[i].suit == temp.cards[j3].suit)
                    {
                      for (int j4 = j3 + 1; j4 > temp.cards.length; j4++)
                      {
                        if (temp.cards[j4].number == '2' &&
                            temp.cards[i].suit == temp.cards[j4].suit)
                        {
                          return 4;
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
    }

    temp = sortBySuit(temp);

    for(int i = 0; i < temp.cards.length; i++)
    {
      //print(temp.cards[i].number + temp.cards[i].suit);
    }

    for(int i = 0; i < temp.cards.length - 4; i++)
    {
      if(hand.cards[i+4].numberRank(hand.cards[i+4].number) == hand.cards[i].numberRank(hand.cards[i].number)-4)
      {
        return hand.cards[i].numberRank(hand.cards[i].number)-1;
      }
    }

    return 0;
  }

  int get4k(Deck hand)
  {
    Deck temp = hand.sortByRank(hand);

    for(int i; i<temp.cards.length; i++)
    {
      if(temp.cards[i].number == temp.cards[i+1].number)
      {
        if(temp.cards[i].number == temp.cards[i+2].number && temp.cards[i].number == temp.cards[i+3].number)
        {
          return temp.cards[i].numberRank(temp.cards[i].number)-1;
        }
      }
    }
    return 0;
  }

  int getFlush(Deck hand)
  {
    Deck temp = hand.sortByRank(hand);
    int t = 0, j = 0;
    var flushsuit;

    if(!isFlush(temp, 0, temp.cards.length))
    {
      return 0;
    }

    List<int> soots = [0,0,0,0]; // (♥, ♦, ♣, ♠)
    for(int i = 0; i < temp.cards.length; i++)
    {
      switch(hand.cards[i].suit)
      {
        case '♥':{soots[0]++;}
        break;
        case '♦':{soots[1]++;}
        break;
        case '♣':{soots[2]++;}
        break;
        case '♠':{soots[3]++;}
      }
    }

    for(int i = 0; i < 4; i++)
      {
        if(soots[i] >= 5)
          {
            switch(i)
            {
              case 0: {flushsuit = '♥';}
              break;
              case 1: {flushsuit = '♦';}
              break;
              case 2: {flushsuit = '♣';}
              break;
              case 3: {flushsuit = '♠';}
            }
          }
      }

    for(int i = 0; j < 5; i++)
      {
        if(temp.cards[i].suit == flushsuit)
          {
            t= t*13 + temp.cards[i].numberRank(temp.cards[i].number)-1;
            j++;
          }
      }

    return t;
  }

  int getStraight(Deck hand)
  {
    Deck temp = hand.sortByRank(hand);

    // checking for A2345 straight
    if(temp.cards[0].number == 'A')
    {
      if(temp.cards[temp.cards.length-1].number == '2')
      {
        if(temp.cards[temp.cards.length-2].number == '3')
        {
          if(temp.cards[temp.cards.length-3].number == '4')
          {
            if(temp.cards[temp.cards.length-4].number == '5')
            {
              return 4;
            }
          }
        }
      }
    }

    for(int i = 0; i < temp.cards.length - 4; i++)
    {
      int k = 4;
      int straightcheck = 0;
      for(int j = 0; j < k; j++)
      {
       // print("${temp.cards[j+i].numberRank(temp.cards[j+i].number)}     ${temp.cards[j+i+1].numberRank(temp.cards[j+i+1].number)}");

        if(temp.cards[i+j].numberRank(temp.cards[i+j].number) != temp.cards[j+i+1].numberRank(temp.cards[j+i+1].number)+1 && temp.cards[j+i].numberRank(temp.cards[j+i].number) != temp.cards[j+i+1].numberRank(temp.cards[j+i+1].number) )
        {
          j +=k;
        }

        if(temp.cards[i+j].numberRank(temp.cards[i+j].number) == temp.cards[i+j+1].numberRank(temp.cards[i+j+1].number)+1)
        {
          straightcheck++;
        }
        if(temp.cards[i+j].numberRank(temp.cards[i+j].number) == temp.cards[i+j+1].numberRank(temp.cards[i+j+1].number))
        {
          k++;
          if(k + i >= temp.cards.length)
          {
            j = k+1;
            i = temp.cards.length;
          }
        }

        if(straightcheck == 4)
        {
          return temp.cards[i+j+1].numberRank(temp.cards[i+j+1].number)-1;
        }
      }
    }
    return 0;

  }

  int getThreeKind(Deck hand)
  {
    Deck temp = hand.sortByRank(hand);

    for(int i = 0; i < temp.cards.length-2; i++)
    {
      if(temp.cards[i].number == temp.cards[i+1].number && temp.cards[i].number == temp.cards[i+2].number )
      {
        return temp.cards[i].numberRank(temp.cards[i].number);
      }
    }
    return 0;
  }

  int getHighPair(Deck hand)
  {
    Deck temp = hand.sortByRank(hand);

    if(!temp.is2Pair(temp))
    {
      return 0;
    }

    for(int i = 0; i < temp.cards.length-3; i++)
    {
      if(temp.cards[i].number == temp.cards[i+1].number)
      {
        for(int j = i+2; j < temp.cards.length-1; j++)
        {
          if(temp.cards[j].number == temp.cards[j+1].number)
          {
            return temp.cards[j].numberRank(temp.cards[j].number)-1;
          }
        }
      }
    }

    return 0;
  }

  int get2PairHigh(Deck hand)
  {
    Deck temp = hand.sortByRank(hand);
    int p=0;

    for(int i = 0; i < temp.cards.length-1; i++)
      {
        if(temp.cards[i].number == temp.cards[i+1].number)
        {
          if(p < 2)
            {
              p++;
              i++;
            }
        }
        else return temp.cards[i].numberRank(temp.cards[i].number)-1;
      }
    return 0;
  }

  int getPair(Deck hand)
  {
    Deck temp = hand.sortByRank(hand);
    for(int i = 0; i < temp.cards.length-1; i++)
    {
      if(temp.cards[i].number == temp.cards[i+1].number)
      {
        return temp.cards[i].numberRank(temp.cards[i].number)-1;
      }
    }

    return 0;
  }

  int getPairHighs(Deck hand)
  {
    Deck temp = hand.sortByRank(hand);
    int t = 0, q=0;

    for(int i = 0; i < temp.cards.length-1; i++)
      {
        if(temp.cards[i].number == temp.cards[i+1].number)
          {
            i++;
          }
        else
          {
            t = t*13 + temp.cards[i].numberRank(temp.cards[i].number);
            q++;
          }
        if(q==3)
          {
            i = temp.cards.length;
          }
      }
    return t;
  }

  int getHighCard(Deck hand)
  {
    Deck temp = hand.sortByRank(hand);
    int t=0;

    for(int i = 0; i < 5; i++)
      {
        t = 13*t + temp.cards[i].numberRank(temp.cards[i].number)-1;
      }

    return t;
  }

  Card dealCard(Deck deck)
  {
    var seed = new Random();
    var rand = new Random(seed.nextInt(seed.nextInt(100)));

    if(deck.cards.length > 1)
      {
        return deck.cards[rand.nextInt(deck.cards.length-1)];
      }
    else return deck.cards[0];
  }

  Deck removeCard(Deck deck, Card dealt)
  {
    deck.cards.remove(dealt);
    return deck;
  }

}

class Card
{
  String suit;
  String number;
  Card({this.suit, this.number});

  Card newCard(String s, String num)
  {
    return Card(
  suit: s,
  number: num);
  }

  int numberRank(String num)
  {
    switch(num)
    {
      case "A":{return 14;}
      case "2":{return 2;}
      case "3":{return 3;}
      case "4":{return 4;}
      case "5":{return 5;}
      case "6":{return 6;}
      case "7":{return 7;}
      case "8":{return 8;}
      case "9":{return 9;}
      case "10":{return 10;}
      case "J":{return 11;}
      case "Q":{return 12;}
      case "K":{return 13;}
    }
    return 0;
  }

  Card randCard()
  {
    var rng = new Random();
    int so = rng.nextInt(3);
    int n = rng.nextInt(12)+1;

    String num, s;

    switch(n)
    {
      case 1:{num = "A";}
      break;
      case 2:{num = "2";}
      break;
      case 3:{num = "3";}
      break;
      case 4:{num = "4";}
      break;
      case 5:{num = "5";}
      break;
      case 6:{num = "6";}
      break;
      case 7:{num = "7";}
      break;
      case 8:{num = "8";}
      break;
      case 9:{num = "9";}
      break;
      case 10:{num = "10";}
      break;
      case 11:{num = "J";}
      break;
      case 12:{num = "Q";}
      break;
      case 13:{num = "K";}
      break;
    }

    switch(so)
    {
      case 0:{s = "♥";}
      break;
      case 1:{s = "♦";}
      break;
      case 2:{s = "♣";}
      break;
      case 3:{s = "♠";}
    }

    return newCard(s, num);

  }

}

class TestHand extends Deck
{
  static final List<Card> lmao = [
    Card(
        number: '9',
        suit: '♦'
    ),
    Card(
      number: '10',
      suit: '♦'
    ),
    Card(
      number: 'J',
      suit: '♦'
    ),
    Card(
      number: 'Q',
      suit: '♦'
    ),

    Card(
        number: 'K',
        suit: '♦'
    )
  ];
  static final Deck testy = Deck(

    cards: lmao,

  ) ;
}

