class Vendingmachine

  # 初期設定
  money = 0
  total_money = 0

  @juice_type = {"コーラ" => 120 ,"レッドブル" => 200 ,"水" => 100 }
  @juice_count = {"コーラ" => 5 ,"レッドブル" => 5 ,"水" => 5 }
  @juice_total_count = @juice_count.values.inject(:+)
  @juice_minimum_price = @juice_type.values.min

  @sales_price = 0

  # 初期アナウンス
  def self.standby(total_money,money)
    money = 0
    @message1 = <<-"EOS"

いらっしゃい
10円、50円、100円、500円、1000円を入れてね。

    EOS

    puts "#{@message1}現在の投入金額は#{total_money}円です！"

    # アクションアナウンス
    if @juice_total_count == 0
      puts "ジュースが在庫切れだよ\n\n"
    elsif total_money < @juice_minimum_price.to_i
      puts "お金が足りないよ！お金入れてね。\n\n"
    else
      puts "ジュースを買いたい場合は[A]って言ってね。\n\n"
    end

    # 買えるものアナウンス
    @juice_type.each_with_index do |(key, value),index|
      juice_count = @juice_count.values[index.to_i]
      puts "#{key}\t#{value}円\t在庫#{juice_count}個"
    end

    #購入かコイン投入か
    howto = gets.chomp
    if howto == "A" #購入の場合
      buy_operation(total_money,money)
    else #コイン挿入の場合
      money = howto.to_i
      money_input(total_money,money)
    end

  end

  # 購入
  def self.buy_operation(total_money,money)
    if @juice_minimum_price.to_i <= total_money && @juice_total_count > 0

      puts "どれを購入しますか？ナンバーを押してください"
      @juice_code = {}

      @juice_type.each_with_index do |(key, value),index|
        @juice_code[key] = index
        puts "[#{index}]\t#{key}\t#{value}円"
      end

      juice_choice = gets.chomp.to_i

      if @juice_code.values.include?(juice_choice)
        if @juice_type.values[juice_choice.to_i] <= total_money
          if @juice_count.values[juice_choice.to_i] > 0

            total_money = total_money.to_i - @juice_type.values[juice_choice.to_i]
            @sales_price = @sales_price.to_i + @juice_type.values[juice_choice.to_i]
            @juice_total_count = @juice_total_count.to_i - 1
            juice_count_new = @juice_count.values[juice_choice.to_i] - 1
            @juice_count.store("#{@juice_count.keys[juice_choice.to_i]}", juice_count_new)

            puts "\n★#{@juice_count.keys[juice_choice]}を購入しました。"
            puts "☆現在の売り上げは#{@sales_price}円。ジュースのトータルの在庫は#{@juice_total_count}個です。"
            puts "☆#{@juice_count.keys[juice_choice]}の在庫は#{@juice_count.values[juice_choice]}個になりました。"
            self.money_output(total_money,money)
          else
            puts "sorry！#{@juice_count.keys[juice_choice]}は在庫がないです。"
          end

        else
          puts "お金、足りないけど・・"
        end

      else
        puts "そのナンバーのジュースはないです。"
      end

    else
      puts "oh、お金がないか、在庫切れです。"
    end

    money_operation(total_money,money)
  end

  # コイン投入、投入金加算
  def self.money_input(total_money,money)
    coins = [10,50,100,500,1000]

    if coins.include?(money)
      total_money = money.to_i + total_money.to_i #total_money += money.to_i
      puts "#{total_money}円が投入されました。" #money_operationで表示するのでmoneyの方がいい?
    else
      puts "投入されたコインは受け付けられません。投入された#{money}円を払い戻しします。現在の投入金額は#{total_money}円です。"
    end
    money = 0  #standbyでmoney = 0 にするので不要?
    money_operation(total_money,money)
  end

  # コイン投入後のアクション選択
  def self.money_operation(total_money,money)
    puts "現在の投入金額は#{total_money}円です。どうしますか？\n[1]\tお金投入\n[2]\t払い戻し\n[3]\t購入"

    money_choice = gets.chomp.to_s
    if money_choice == "1"
      self.standby(total_money,money)
    elsif money_choice == "2"
      self.money_output(total_money,money)
    elsif money_choice == "3"
      self.buy_operation(total_money,money)
    else
      puts "FACK!"  #スペルミス
      money_operation(total_money,money)
    end
  end

  # 払い戻し or 購入後自動釣り銭
  def self.money_output(total_money,money)
    puts "#{total_money}円を払い戻しします。"
    total_money = 0
    self.standby(total_money,money)
  end

  self.standby(total_money,money)
end
