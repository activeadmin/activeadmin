require 'rails_helper'

RSpec.describe ActiveAdmin::Dependency do
  k = ActiveAdmin::Dependency

  describe 'method_missing' do
    before do
      allow(Gem).to receive(:loaded_specs)
        .and_return 'foo' => Gem::Specification.new('foo', '1.2.3')
    end

    it 'returns a Matcher' do
      expect(k.foo).to be_a ActiveAdmin::Dependency::Matcher
      expect(k.foo.inspect).to eq '<ActiveAdmin::Dependency::Matcher for foo 1.2.3>'
      expect(k.bar.inspect).to eq '<ActiveAdmin::Dependency::Matcher for (missing)>'
    end

    describe '`?`' do
      it 'base' do
        expect(k.foo?).to eq true
        expect(k.bar?).to eq false
      end
      it '=' do
        expect(k.foo? '= 1.2.3').to eq true
        expect(k.foo? '= 1').to eq false
      end
      it '>' do
        expect(k.foo? '> 1').to eq true
        expect(k.foo? '> 2').to eq false
      end
      it '<' do
        expect(k.foo? '< 2').to eq true
        expect(k.foo? '< 1').to eq false
      end
      it '>=' do
        expect(k.foo? '>= 1.2.3').to eq true
        expect(k.foo? '>= 1.2.2').to eq true
        expect(k.foo? '>= 1.2.4').to eq false
      end
      it '<=' do
        expect(k.foo? '<= 1.2.3').to eq true
        expect(k.foo? '<= 1.2.4').to eq true
        expect(k.foo? '<= 1.2.2').to eq false
      end
      it '~>' do
        expect(k.foo? '~> 1.2.0').to eq true
        expect(k.foo? '~> 1.1').to eq true
        expect(k.foo? '~> 1.2.4').to eq false
      end
    end

    describe '`!`' do
      it 'raises an error if requirement not met' do
        expect { k.foo! '5'            }.to raise_error ActiveAdmin::DependencyError,
          'You provided foo 1.2.3 but we need: 5.'
      end
      it 'accepts multiple arguments' do
        expect { k.foo! '> 1', '< 1.2' }.to raise_error ActiveAdmin::DependencyError,
          'You provided foo 1.2.3 but we need: > 1, < 1.2.'
      end
      it 'raises an error if not provided' do
        expect { k.bar!                }.to raise_error ActiveAdmin::DependencyError,
          'To use bar you need to specify it in your Gemfile.'
      end
    end
  end

  describe '[]' do
    before do
      allow(Gem).to receive(:loaded_specs)
        .and_return 'a-b' => Gem::Specification.new('a-b', '1.2.3')
    end

    it 'allows access to gems with an arbitrary name' do
      expect(k['a-b']).to be_a ActiveAdmin::Dependency::Matcher
      expect(k['a-b'].inspect).to eq '<ActiveAdmin::Dependency::Matcher for a-b 1.2.3>'
      expect(k['c-d'].inspect).to eq '<ActiveAdmin::Dependency::Matcher for (missing)>'
    end

    # Note: more extensive tests for match? and match! are above.

    it 'match?' do
      expect(k['a-b'].match?).to eq true
      expect(k['a-b'].match? '1.2.3').to eq true
      expect(k['b-c'].match?).to eq false
    end

    it 'match!' do
      expect(k['a-b'].match!).to eq nil
      expect(k['a-b'].match! '1.2.3').to eq nil

      expect { k['a-b'].match! '2.5' }.to raise_error ActiveAdmin::DependencyError,
        'You provided a-b 1.2.3 but we need: 2.5.'

      expect { k['b-c'].match!       }.to raise_error ActiveAdmin::DependencyError,
        'To use b-c you need to specify it in your Gemfile.'
    end

    # Note: Ruby comparison operators are separate from the `foo? '> 1'` syntax

    describe 'Ruby comparison syntax' do
      it '==' do
        expect(k['a-b'] == '1.2.3').to eq true
        expect(k['a-b'] == '1.2').to eq false
        expect(k['a-b'] == 1).to eq false
      end
      it '>' do
        expect(k['a-b'] > 1).to eq true
        expect(k['a-b'] > 2).to eq false
      end
      it '<' do
        expect(k['a-b'] < 2).to eq true
        expect(k['a-b'] < 1).to eq false
      end
      it '>=' do
        expect(k['a-b'] >= '1.2.3').to eq true
        expect(k['a-b'] >= '1.2.2').to eq true
        expect(k['a-b'] >= '1.2.4').to eq false
      end
      it '<=' do
        expect(k['a-b'] <= '1.2.3').to eq true
        expect(k['a-b'] <= '1.2.4').to eq true
        expect(k['a-b'] <= '1.2.2').to eq false
      end

      it 'throws a custom error if the gem is missing' do
        expect { k['b-c'] < 23 }.to raise_error ActiveAdmin::DependencyError,
          'To use b-c you need to specify it in your Gemfile.'
      end
    end
  end
end
