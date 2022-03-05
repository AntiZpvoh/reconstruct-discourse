# frozen_string_literal: true

require 'i18n/backend/fallback_locale_list'

describe I18n::Backend::FallbackLocaleList do
  let(:list) { I18n::Backend::FallbackLocaleList.new }

  it "works when default_locale is English" do
    SiteSetting.default_locale = :en

    expect(list[:ru]).to eq([:ru, :en])
    expect(list[:en]).to eq([:en])
  end

  it "works when default_locale is English (UK)" do
    SiteSetting.default_locale = :en_GB

    expect(list[:ru]).to eq([:ru, :en])
    expect(list[:en_GB]).to eq([:en_GB, :en])
    expect(list[:en]).to eq([:en])
  end

  it "works when default_locale is not English" do
    SiteSetting.default_locale = :de

    expect(list[:ru]).to eq([:ru, :en])
    expect(list[:de]).to eq([:de, :en])
    expect(list[:en]).to eq([:en])
    expect(list[:en_GB]).to eq([:en_GB, :en])
  end

  context "when plugin registered fallback locale" do
    before do
      DiscoursePluginRegistry.register_locale("es_MX", fallbackLocale: "es")
      DiscoursePluginRegistry.register_locale("de_AT", fallbackLocale: "de")
      DiscoursePluginRegistry.register_locale("de_AT-formal", fallbackLocale: "de_AT")
    end

    after do
      DiscoursePluginRegistry.reset!
    end

    it "works when default_locale is English" do
      SiteSetting.default_locale = :en

      expect(list[:de_AT]).to eq([:de_AT, :de, :en])
      expect(list[:"de_AT-formal"]).to eq([:"de_AT-formal", :de_AT, :de, :en])
      expect(list[:de]).to eq([:de, :en])
      expect(list[:en]).to eq([:en])
    end

    it "works when default_locale is English (UK)" do
      SiteSetting.default_locale = :en_GB

      expect(list[:de_AT]).to eq([:de_AT, :de, :en])
      expect(list[:"de_AT-formal"]).to eq([:"de_AT-formal", :de_AT, :de, :en])
      expect(list[:de]).to eq([:de, :en])
      expect(list[:en]).to eq([:en])
      expect(list[:en_GB]).to eq([:en_GB, :en])
    end

    it "works when default_locale is not English" do
      SiteSetting.default_locale = :de

      expect(list[:es_MX]).to eq([:es_MX, :es, :en])
      expect(list[:"de_AT-formal"]).to eq([:"de_AT-formal", :de_AT, :de, :en])
      expect(list[:es]).to eq([:es, :en])
      expect(list[:en]).to eq([:en])
    end
  end
end
