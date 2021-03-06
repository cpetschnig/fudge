require 'spec_helper'

describe Fudge::Formatters::Simple do
  let(:stdout) { StringIO.new }

  subject { described_class.new(stdout) }

  describe :error do
    it "returns message in RED" do
      string = subject.error "a message"
      string.should == "\e[31ma message\e[0m"
    end
  end

  describe :success do
    it "returns message in BRIGHT GREEN" do
      string = subject.success "a message"
      string.should == "\e[1m\e[32ma message\e[0m"
    end
  end

  describe :info do
    it "returns message in CYAN" do
      string = subject.info "a message"
      string.should == "\e[36ma message\e[0m"
    end
  end

  describe :notice do
    it "returns message in YELLOW" do
      string = subject.notice "a message"
      string.should == "\e[33ma message\e[0m"
    end
  end

  describe :normal do
    it "returns unchanged message" do
      string = subject.normal "a message"
      string.should == "a message"
    end
  end

  describe :puts do
    it "outputs message on stdout" do
      subject.puts "a message"
      stdout.string.should == "a message" + "\n"
    end
  end

  describe :write do
    it "supports chaining types to stdout" do
      subject.write do |w|
        w.normal('normal').
          notice('notice').
          info('info').
          success('success').
          error('error')
      end

      stdout.string.should == 'normal' + ' ' +
                              "\e[33mnotice\e[0m" + ' ' +
                              "\e[36minfo\e[0m" + ' ' +
                              "\e[1m\e[32msuccess\e[0m" + ' ' +
                              "\e[31merror\e[0m" + "\n"

    end
  end
end
